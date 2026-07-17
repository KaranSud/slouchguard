---
name: slouchguard
description: Install, update, uninstall, or troubleshoot the SlouchGuard posture app for Mac, and answer questions about the user's posture stats (posture score, slouch count, corrections, time slouched). Use when the user mentions SlouchGuard, posture, slouching, sitting posture, or asks how their posture has been today or this week.
---

# SlouchGuard

SlouchGuard is a Mac menu bar app — free to use, with an optional paid Pro upgrade — that
uses AirPods motion sensors (AirPods Pro / Max / 3rd gen+ / Beats Fit Pro) to detect
slouching and send gentle notifications. Everything runs on-device. It is proprietary
software (not open source). Home: https://github.com/KaranSud/slouchguard

## Install or update the app

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/KaranSud/slouchguard/main/scripts/install.sh | bash
```

This downloads the latest release, installs to /Applications, clears the Gatekeeper
quarantine flag (the app is ad-hoc signed, not notarized), and launches it.

After installing, tell the user to:
1. Allow Motion & Fitness and notification access when prompted.
2. Put in their AirPods and wait for the menu bar icon to react.
3. Click the menu bar icon and hit Calibrate while sitting upright.

Updating is the same command; the installer replaces the existing app cleanly.

## Check whether it is installed / running

```bash
ls /Applications/SlouchGuard.app >/dev/null 2>&1 && echo installed || echo "not installed"
pgrep -x SlouchGuard >/dev/null && echo running || echo "not running"
```

If installed but not running: `open /Applications/SlouchGuard.app`

## Answer posture questions from stats

Stats live in `~/Library/Application Support/SlouchGuard/stats/` as one JSON file
per day named `YYYY-MM-DD.json` with these keys:

- `postureScore`: 0 to 100, share of monitored time in good posture (100 = never slouched or lounged)
- `slouchCount`: number of distinct slouches — leaning forward (5 seconds or longer)
- `totalSlouchSeconds`: total time spent slouching forward
- `loungeCount`: number of distinct lounges — leaning back too far (5 seconds or longer)
- `totalLoungeSeconds`: total time spent leaning back
- `corrections`: times the user returned to good posture (from either direction)
- `alerts`: notifications sent
- `monitoredSeconds`: total time AirPods were in and monitoring was active
- `hourlyPoorSeconds`: 24-element array (index = hour of day) of poor-posture seconds;
  the highest index is the hour the user slouches/lounges most (a Pro "time of day" insight)

To answer "how is my posture today", read today's file. For "this week", read the
last 7 files and compare. Summarize conversationally: lead with the score, mention
the trend if multiple days are available, and keep it encouraging rather than
judgmental. If `monitoredSeconds` is 0 or the file is missing, the user was not
wearing AirPods that day; say so instead of inventing numbers.

## Troubleshooting

- **No icon in menu bar**: app not running, `open /Applications/SlouchGuard.app`.
- **Icon never leaves the AirPods state**: unsupported headphones (needs AirPods
  Pro/Max/3rd gen+ or Beats Fit Pro), or Motion & Fitness permission denied. Check
  System Settings → Privacy & Security → Motion & Fitness.
- **No notifications**: check System Settings → Notifications → SlouchGuard.
- **Alerts feel wrong**: recalibrate (menu bar → Calibrate) or change Sensitivity
  (Low 18° / Medium 12° / High 8° / Maximum 5°).

## Uninstall

```bash
pkill -x SlouchGuard 2>/dev/null; rm -rf /Applications/SlouchGuard.app
defaults delete com.karansud.slouchguard 2>/dev/null
rm -rf "$HOME/Library/Application Support/SlouchGuard"   # only if the user wants stats gone too
```
