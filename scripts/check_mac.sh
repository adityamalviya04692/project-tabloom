#!/bin/bash
# Checks that this Mac can build and test the project. Read-only; changes nothing.
ok=1
say() { printf '%-28s %s\n' "$1" "$2"; }

say "macOS" "$(sw_vers -productVersion 2>/dev/null || echo 'not macOS')"
arch=$(uname -m); say "CPU architecture" "$arch $([ "$arch" = arm64 ] && echo '(Apple Silicon, good)')"

if xcode-select -p >/dev/null 2>&1; then say "Developer tools path" "$(xcode-select -p)"
else say "Developer tools" "MISSING -> run: xcode-select --install"; ok=0; fi

if command -v swift >/dev/null 2>&1; then
  say "Swift" "$(swift --version 2>&1 | head -1)"
else say "Swift" "MISSING -> install Xcode or Command Line Tools"; ok=0; fi

if [ -d "/Applications/Xcode.app" ]; then say "Xcode" "installed"
else say "Xcode" "not installed (OK: Command Line Tools are enough for swift build; 'swift test' with Swift Testing may need Xcode)"; fi

if [ -d "/Applications/Google Chrome.app" ]; then
  say "Google Chrome" "$(defaults read '/Applications/Google Chrome.app/Contents/Info' CFBundleShortVersionString)"
else say "Google Chrome" "MISSING in /Applications"; ok=0; fi

echo; [ $ok = 1 ] && echo "All good. Next: see TESTING.md" || echo "Fix the MISSING items above, then re-run."
