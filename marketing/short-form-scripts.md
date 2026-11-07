# Short-Form Scripts (YouTube Shorts / Reels / TikTok / X video)

Date: 2026-11-05. Format: 9:16, 1080×1920, 15–45 s, burned-in captions (most people watch muted). **[Inference]**

**Hard rule:** any shot showing the after-state (separate profile apps in ⌘-Tab) must be a real recording of a build that passed the manual ⌘-Tab check. Until then, record only the "before" pain and the build-in-public pieces (S6–S10).

Recording kit: macOS screen recording (⌘-⇧-5) at 2× zoom on the ⌘-Tab overlay; show key presses with an on-screen keystroke overlay (e.g. KeyCastr, open source); use a clean demo user account with obviously fake profile names ("Work", "Personal", "Client: Acme").

---

### S1: "⌘-Tab only shows one Chrome" (flagship before/after)
- **Platform:** Shorts, Reels, X, TikTok · **Length:** 15–20 s · **Objective:** awareness → site visit · **Effort:** S
- **Hook (0–2 s, text on screen):** "I have 4 Chrome profiles. ⌘-Tab shows ONE."
- **0–6 s:** Press ⌘-Tab, one Chrome tile. Cycle ⌘-\` through mixed windows. Caption: "Work? Personal? Client? Good luck."
- **6–8 s:** Hard cut, caption: "So I made each profile its own Mac app."
- **8–15 s:** ⌘-Tab: Chrome · Work (red W) · Personal (blue P) · Acme (logo). Pick Work and only Work windows come forward.
- **15–18 s:** Caption: "Real ⌘-Tab. Own Dock icons. No subscription." End card: "tabloom.app" ⚠️ (domain TBD)
- **CTA (pinned comment):** "Beta link in bio. Mac + Chrome only for now."
- **Visuals needed:** verified after-state recording.

### S2: "Stop sharing the wrong Chrome window"
- **Platform:** Reels, TikTok, LinkedIn video · **Length:** 20 s · **Objective:** problem resonance (consultants/agencies)
- **Hook:** "POV: you share your screen and your personal Gmail is right there."
- **Beats:** Zoom call mock (no real people), presenter ⌘-Tabs to Chrome and the wrong profile window appears → wince → caption "Fix: one app per Chrome profile" → ⌘-Tab straight to "Client: Acme".
- **CTA:** "How I set it up → link."
- **Visuals:** fake call UI built in Keynote; verified after-state.

### S3: "Why does macOS do this?" (explainer)
- **Platform:** Shorts, TikTok, X · **Length:** 35–45 s · **Objective:** credibility; feeds T1 blog · **Effort:** M
- **Hook:** "Here's why every Chrome profile hides behind one icon."
- **Script (voice-over):** "⌘-Tab doesn't list windows. It lists apps, one per running process. And Chrome runs every profile in one process on purpose: launch it again and the new copy hands off to the running one and quits. So to get Work and Personal into ⌘-Tab separately, each one needs its own process. Each process needs its own data folder. And macOS needs to see each one as its own app. That's what I built." Cut to after-state.
- **Visuals:** simple animated diagram (1 process → 1 icon; 3 processes → 3 icons), filmed whiteboard or Keynote animation.
- **CTA:** "Full write-up linked."

### S4: "Dock glow-up"
- **Platform:** Reels, TikTok · **Length:** 10–12 s · **Objective:** aesthetic share/save
- **Beats:** Dock with one Chrome → satisfying transition → Dock with 3 colour-coded profile icons. Music-driven (licensed in-app audio only).
- **Caption:** "Every Chrome profile, its own app. Mac only."

### S5: "Agency owner setup: one app per client"
- **Platform:** LinkedIn, Reels · **Length:** 30 s · **Objective:** segment test (agencies)
- **Hook:** "I manage 6 clients' Google accounts. This is my Dock."
- **Beats:** Show 6 client-coloured profile apps (fake client names), Spotlight → type "Acme" → opens that client's Chrome. Caption about no more logging out and back in.
- ⚠️ Only use if research confirms the agency segment (see customer-research.md).

### S6: Build in public: "Day 1, can I even do this?"
- **Platform:** X, Shorts · **Length:** 30 s · **Objective:** build-in-public following · **Effort:** S (footage exists conceptually from spike)
- **Script:** "I want each Chrome profile to show up in ⌘-Tab on its own. Attempt 1: shortcuts with a profile flag. Same process, one icon. Fail. Attempt 2: symlink Chrome into a new app. Chrome's GPU sandbox kills it. Fail. Attempt 3: tomorrow." Terminal clips + error message on screen.

### S7: Build in public: "The bug that taught me Chrome's sandbox"
- **Platform:** X thread + 30 s clip · Hook: "Chrome refused to start. The error: 'GPU process isn't usable.'" Explain the symlink + Seatbelt sandbox read restriction in 3 captions → APFS clone fix.

### S8: Build in public: "725 MB app, 0 bytes on disk"
- **Platform:** X, Shorts · Hook: "Finder says 725 MB. My disk says 0." Show `du` vs `df` before/after → explain APFS clones in one sentence. ⚠️ re-measure on shipping build.

### S9: "I'm pricing my Mac app at $4.99. Here's the maths."
- **Platform:** X, LinkedIn, IH · Talking-head or text card · Use the real fee table from pricing-strategy.md. CTA: "What would you pay?" (honest poll, no fake numbers).

### S10: "Things this app does NOT do" (trust)
- **Platform:** X, Reels · 15 s list card: no Accessibility permission, no background process, no tracking, doesn't modify Chrome, no subscription. Each line must match the claim gate.

---

## Posting cadence suggestion [Inference]
- Pre-launch: S6, S7, S8 (build in public), 2–3 per week on X and Shorts.
- Launch week: S1 (pinned), S3, S2.
- Post-launch: S4, S5, S9, S10 + replies to every comment for the first 48 h.
- Re-cut the same footage for every platform; only change the hook text and the CTA.
