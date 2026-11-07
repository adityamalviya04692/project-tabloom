import AppKit
import Foundation

public enum IconSource {
    /// Rounded square with initials on a solid colour (0xRRGGBB).
    case initials(String, color: UInt32)
    /// Any image NSImage can read (PNG/JPEG/ICNS, Chrome's Google account picture).
    case image(URL)
    /// The installed Chrome's own logo on white, with the name band in the profile's colour (0xRRGGBB).
    case chrome(URL, color: UInt32)
}

/// Builds .icns files with AppKit + iconutil. Purely local; nothing is uploaded.
public enum IconGenerator {
    /// `label` (normally the profile name) is drawn in a band at the bottom of the icon so it is
    /// readable in the Cmd-Tab strip and Dock. Sizes of 32 px and below omit it (it would be illegible).
    public static func makeICNS(_ source: IconSource, label: String? = nil, to output: URL) throws {
        let labeled = try render(source, label: label)
        let plain = label == nil ? labeled : try render(source, label: nil)
        let fm = FileManager.default
        let iconset = fm.temporaryDirectory.appendingPathComponent("pd-\(UUID().uuidString).iconset")
        try fm.createDirectory(at: iconset, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: iconset) }
        for s in [16, 32, 128, 256, 512] {
            try png(s <= 32 ? plain : labeled, size: s).write(to: iconset.appendingPathComponent("icon_\(s)x\(s).png"))
            try png(s * 2 <= 32 ? plain : labeled, size: s * 2).write(to: iconset.appendingPathComponent("icon_\(s)x\(s)@2x.png"))
        }
        try Tool.run("/usr/bin/iconutil", ["-c", "icns", iconset.path, "-o", output.path])
    }

    static let canvas = NSSize(width: 1024, height: 1024)
    static let inset = NSRect(x: 100, y: 100, width: 824, height: 824) // macOS icon grid margin
    static let bandHeight: CGFloat = 250

    static func render(_ source: IconSource, label: String?) throws -> NSImage {
        let clip = NSBezierPath(roundedRect: inset, xRadius: 185, yRadius: 185)
        let label = label.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.flatMap { $0.isEmpty ? nil : $0 }
        // With a label, the artwork's visual centre moves up into the area above the band.
        let artCenterY = label == nil ? inset.midY : inset.minY + bandHeight + (inset.height - bandHeight) / 2
        var picture: NSImage?
        var bandColor: UInt32?
        switch source {
        case .image(let url):
            guard let img = NSImage(contentsOf: url), img.isValid else {
                throw DockError.toolFailed("icon", 1, "Unreadable image: \(url.lastPathComponent)")
            }
            picture = img
        case .chrome(let app, let color):
            guard FileManager.default.fileExists(atPath: app.appendingPathComponent("Contents/Info.plist").path) else {
                throw DockError.chromeNotFound(app.path)
            }
            picture = NSWorkspace.shared.icon(forFile: app.path) // largest representation, from Assets.car
            bandColor = color
        case .initials:
            break
        }
        return NSImage(size: canvas, flipped: false) { _ in
            NSGraphicsContext.saveGraphicsState()
            clip.addClip()
            switch source {
            case .initials(let text, let color):
                nsColor(color).setFill(); inset.fill()
                let fontSize: CGFloat = (text.count > 1 ? 360 : 440) * (label == nil ? 1 : 0.8)
                let s = NSAttributedString(string: text, attributes: [
                    .font: NSFont.systemFont(ofSize: fontSize, weight: .bold), .foregroundColor: NSColor.white])
                let sz = s.size()
                s.draw(at: NSPoint(x: inset.midX - sz.width / 2, y: artCenterY - sz.height / 2))
            case .image:
                let img = picture!
                // Aspect-fill into the icon shape.
                let scale = max(inset.width / img.size.width, inset.height / img.size.height)
                let w = img.size.width * scale, h = img.size.height * scale
                img.draw(in: NSRect(x: inset.midX - w / 2, y: inset.midY - h / 2, width: w, height: h))
            case .chrome:
                NSColor.white.setFill(); inset.fill()
                // Only the round logo is taken from Chrome's icon (its own white tile and edge are dropped):
                // in Chrome's 1024 grid the logo is a circle of radius ~330 around the centre.
                let logoRadius: CGFloat = label == nil ? 300 : 225
                let scale = logoRadius / 330
                let side = 1024 * scale
                let center = NSPoint(x: inset.midX, y: artCenterY)
                NSGraphicsContext.saveGraphicsState()
                NSBezierPath(ovalIn: NSRect(x: center.x - logoRadius, y: center.y - logoRadius,
                                            width: logoRadius * 2, height: logoRadius * 2)).addClip()
                picture!.draw(in: NSRect(x: center.x - side / 2, y: center.y - side / 2, width: side, height: side))
                NSGraphicsContext.restoreGraphicsState()
            }
            if let label { drawBand(label, color: bandColor) }
            NSGraphicsContext.restoreGraphicsState()
            return true
        }
    }

    /// Band with the name, shrunk to fit and truncated with "…" if still too long. Dark translucent over
    /// pictures; solid profile colour (with black or white text, whichever reads better) for Chrome icons.
    static func drawBand(_ text: String, color: UInt32? = nil) {
        let band = NSRect(x: inset.minX, y: inset.minY, width: inset.width, height: bandHeight)
        var textColor = NSColor.white
        if let color {
            nsColor(color).setFill()
            if luminance(color) > 0.6 { textColor = NSColor(white: 0.1, alpha: 1) }
        } else {
            NSColor(white: 0, alpha: 0.45).setFill()
        }
        band.fill()
        let maxWidth = inset.width - 110 // stay clear of the rounded corners
        let para = NSMutableParagraphStyle(); para.lineBreakMode = .byTruncatingTail; para.alignment = .center
        var size: CGFloat = 170
        func attributed(_ size: CGFloat) -> NSAttributedString {
            NSAttributedString(string: text, attributes: [.font: NSFont.systemFont(ofSize: size, weight: .semibold),
                                                          .foregroundColor: textColor, .paragraphStyle: para])
        }
        while size > 80, attributed(size).size().width > maxWidth { size -= 4 }
        let s = attributed(size)
        let h = s.size().height
        s.draw(with: NSRect(x: band.midX - maxWidth / 2, y: band.midY - h / 2 + size * 0.1, width: maxWidth, height: h),
               options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine])
    }

    static func png(_ image: NSImage, size: Int) throws -> Data {
        guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size,
                                         bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                         colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)
        else { throw DockError.toolFailed("icon", 1, "bitmap allocation") }
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        NSGraphicsContext.current?.imageInterpolation = .high
        image.draw(in: NSRect(x: 0, y: 0, width: size, height: size))
        NSGraphicsContext.restoreGraphicsState()
        guard let data = rep.representation(using: .png, properties: [:]) else {
            throw DockError.toolFailed("icon", 1, "PNG encode")
        }
        return data
    }

    static func nsColor(_ rgb: UInt32) -> NSColor {
        NSColor(srgbRed: CGFloat((rgb >> 16) & 0xFF) / 255, green: CGFloat((rgb >> 8) & 0xFF) / 255,
                blue: CGFloat(rgb & 0xFF) / 255, alpha: 1)
    }

    /// Relative luminance (sRGB, 0…1).
    static func luminance(_ rgb: UInt32) -> Double {
        func lin(_ c: UInt32) -> Double { let v = Double(c) / 255; return v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4) }
        return 0.2126 * lin((rgb >> 16) & 0xFF) + 0.7152 * lin((rgb >> 8) & 0xFF) + 0.0722 * lin(rgb & 0xFF)
    }

    /// Band colour for a Chrome profile. Chrome's own colour is used only when it is vivid (a theme the user
    /// picked); Chrome's default dark tones are near-identical across profiles, so otherwise each profile gets
    /// a distinct colour from a 14-colour palette indexed by its number ("Profile 7" → 7, "Default" → 0).
    public static func profileColor(directory: String, chromeColor: UInt32?) -> UInt32 {
        if let c = chromeColor {
            let ns = nsColor(c)
            if ns.saturationComponent >= 0.35, ns.brightnessComponent >= 0.45 { return c }
        }
        let palette: [UInt32] = [0x1A73E8, 0xD93025, 0x188038, 0xE37400, 0x9334E6, 0x007B83, 0xC2185B,
                                 0x3949AB, 0x795548, 0x5F6368, 0xF9AB00, 0x00ACC1, 0x7CB342, 0x202124]
        let digits = directory.reversed().prefix { $0.isNumber }
        let index = directory == "Default" ? 0 : Int(String(digits.reversed())) ?? Int(SafeNames.fnv1a(directory) % 14)
        return palette[index % palette.count]
    }

    /// Deterministic pleasant colour for profiles without one.
    public static func defaultColor(for key: String) -> UInt32 {
        let palette: [UInt32] = [0x1A73E8, 0xD93025, 0x188038, 0xE37400, 0x9334E6, 0x007B83, 0xC5221F, 0x5F6368]
        return palette[Int(SafeNames.fnv1a(key) % UInt32(palette.count))]
    }
}
