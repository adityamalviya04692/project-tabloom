# FAQ (publishable draft)

Status date: 2026-11-05. Answers marked ⚠️ must be re-checked against the shipping build before publishing.

**What does Tabloom do?**
It turns a Chrome profile into its own small Mac app. Each one gets its own Dock icon, its own name and its own entry in the normal macOS ⌘-Tab switcher, so "Chrome · Work" and "Chrome · Personal" stop hiding behind one icon.

**Is this a custom app switcher?**
No. Tabloom doesn't replace or imitate ⌘-Tab. Each profile app is a real running app, so macOS lists it in the standard switcher on its own.

**Does it need Accessibility or Screen Recording permission?**
No. Tabloom doesn't watch your windows or keystrokes, and nothing runs in the background after your apps are built.

**Will my existing Chrome profiles, logins and cookies carry over?** ⚠️
Not yet. Today each Tabloom app starts with a fresh Chrome profile. Sign in to Chrome once inside it and Chrome Sync brings back bookmarks, extensions, history and saved passwords. Site logins (cookies) need one sign-in per site. Importing an existing profile is being tested and will only ship once it's proven safe for your data.

**Does Tabloom change my normal Chrome?**
No. Your regular Google Chrome app and its profiles are not modified. Tabloom apps keep their data in a separate folder.

**Is it safe? Does it send my data anywhere?**
Tabloom has no account system and no tracking by default. It never reads your browsing data, passwords or profile contents. ⚠️ Optional anonymous crash/usage reporting, if added, will be off unless you turn it on.

**What happens when Chrome updates?** ⚠️
Each profile app uses the Chrome engine that was installed when it was built. After Chrome updates, Tabloom rebuilds your apps so they run the latest, patched version. Rebuilding keeps your profile data. *(Only publish once the update/repair flow ships and is tested.)*

**Does it use a lot of disk space?** ⚠️
On APFS (the default on modern Macs), the Chrome engine is cloned, not copied, so a new app takes almost no extra space. After a Chrome update, space grows until the apps are rebuilt.

**Which Macs and Chrome versions are supported?** ⚠️
Tested on: macOS 26.1, Apple Silicon, Google Chrome 156. Not yet tested: Intel Macs, older macOS versions, Chrome Beta/Canary. See the compatibility table for the current list.

**Does it work with Brave, Edge, Arc or Firefox?**
Not right now. Tabloom supports Google Chrome only. Join the list if you want another browser.

**Can I give each profile its own icon?**
Yes: pick a letter, colour, emoji or your own image.

**Can I keep using Chrome's own profile menu?**
Yes. Your regular Chrome still works as usual. Profiles inside Tabloom apps are separate from the ones in Chrome's profile menu.

**How do I uninstall?**
Delete a profile app from Tabloom (or drag it to the Trash) and remove Tabloom. ⚠️ Tabloom removes the app's registration and, if you choose, its profile data.

**How much does it cost? Is there a subscription?**
$4.99 once. No subscription. Updates for version 1 are included. ⚠️ (final price depends on the pricing test)

**Is there a refund policy?**
Yes — if it doesn't work on your Mac, email within 14 days for a refund. ⚠️ (align with the merchant-of-record's policy)

**How is this different from Unbundle?** ⚠️
See our dated, factual comparison page. *(Publish only the facts that competitor-analysis.md verified, with the check date.)*

**Is Tabloom made by Google?**
No. Google Chrome is a trademark of Google LLC. Tabloom is an independent app and isn't affiliated with or endorsed by Google.
