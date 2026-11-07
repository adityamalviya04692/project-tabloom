// Usage: make_icon <out.png> <hexcolor> <text>  — renders a 1024px rounded-square icon.
import AppKit
let a = CommandLine.arguments
let hex = UInt32(a[2], radix: 16)!
let color = NSColor(red: CGFloat((hex >> 16) & 0xff)/255, green: CGFloat((hex >> 8) & 0xff)/255,
                    blue: CGFloat(hex & 0xff)/255, alpha: 1)
let size = 1024
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8,
    samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let rect = NSRect(x: 100, y: 100, width: 824, height: 824)
color.setFill(); NSBezierPath(roundedRect: rect, xRadius: 185, yRadius: 185).fill()
let attrs: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: 440, weight: .bold), .foregroundColor: NSColor.white]
let s = NSAttributedString(string: a[3], attributes: attrs); let sz = s.size()
s.draw(at: NSPoint(x: (CGFloat(size) - sz.width)/2, y: (CGFloat(size) - sz.height)/2))
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: a[1]))
