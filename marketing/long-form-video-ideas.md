# Long-Form Video Ideas (YouTube, 6–15 min)

Date: 2026-11-05. Labels: **[Inference]** / **[Hypothesis]**. After-state footage must be a real recording of a verified build.

## L1: "Every Chrome profile as its own Mac app (native ⌘-Tab)": product walkthrough
- **Audience:** Mac power users searching for a fix · **Objective:** conversion + evergreen search on YouTube · **Effort:** M
- **Outline:** 0:00 the problem (one ⌘-Tab icon) → 0:45 why it happens (process singleton, 60 s version) → 2:00 install → 3:00 create Work/Personal/Client apps, pick icons → 5:00 daily use: ⌘-Tab, Dock, Spotlight, Stage Manager/Spaces ⚠️ (only the window behaviour that's tested) → 7:00 what to know: fresh profile + Chrome Sync, Chrome updates, uninstall → 8:30 price + link.
- **Title options:** "Get Chrome Profiles in ⌘-Tab on Mac (Separate Apps)" / "Fix: Chrome Profiles All Under One Icon on macOS"
- **Chapters + description:** link to the guide article and the FAQ.

## L2: "I built a native Mac app to fix Chrome profiles: here's everything that broke"
- **Audience:** developers, indie hackers · **Objective:** build-in-public, HN/X amplification · **Effort:** M–L
- **Outline:** idea → 3 failed approaches (shortcut flags, stub apps + Accessibility, symlink + sandbox) → the per-app bundle + `execv` trick → APFS clones → the Chrome-update and Keychain problems → what's next.
- **Source material:** TECHNICAL_SPIKE.md, technical-blog-ideas.md T1.

## L3: "How Chrome profiles actually work (user-data-dir, Local State, Sync)"
- **Audience:** curious power users, IT admins · **Objective:** SEO-style evergreen authority · **Effort:** M
- **Outline:** profile folders on disk, `Local State`, what Sync does and doesn't restore, cookies vs synced data, why sharing a profile between two Chromes corrupts it. No product pitch until the last 30 s.

## L4: "Managing 10 client Google accounts on one Mac without losing your mind"
- **Audience:** freelancers, agencies, consultants · **Objective:** segment validation (agencies) · **Effort:** M
- **Outline:** compare options honestly: Chrome profiles alone, Firefox containers, Arc/Dia spaces, separate macOS users, link routers (Choosy/Velja/Finicky) for opening links in the right profile, and Tabloom for ⌘-Tab separation. Mention competitors fairly with dated facts from competitor-analysis.md.
- **Why:** comparison videos earn trust and rank for "alternative" queries **[Inference]**.

## L5: "Building and selling a $4.99 Mac utility with AI coding tools: real numbers"
- **Audience:** indie hackers · **Objective:** IH/X/YouTube build-in-public · **Effort:** M · **Timing:** 30–60 days after launch, with real revenue, refund and support numbers (no projections presented as results).

## L6: "Mac app bundles explained: what's inside a .app and how macOS decides what's in ⌘-Tab"
- **Audience:** Swift/macOS devs · **Objective:** dev authority, backlinks · **Effort:** M

## Production notes
- Record the screen at 1440p or higher with system font size bumped up; zoom in post on the ⌘-Tab overlay.
- Thumbnail pattern: big "⌘-Tab" glyph with 1 Chrome icon → arrow → 3 coloured icons. Text ≤ 4 words.
- Pin a comment with the link and the "Mac + Chrome only, fresh profiles" caveat to cut down on refunds.
- Repurpose: each long-form video gets cut into 3–5 Shorts (see short-form-scripts.md).
