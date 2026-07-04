<div align="center">

# SlouchGuard

**Your AirPods already know when you slouch. SlouchGuard tells you.**

A posture coach for Mac. No camera, no wearable, no account, and nothing ever leaves your machine. Free to use, with an optional Pro upgrade.

[Install](#install) · [Free vs Pro](#free-vs-pro) · [How it works](#how-it-works) · [Claude Code skill](#claude-code-skill) · [FAQ](#faq)

</div>

## What it does

SlouchGuard reads the motion sensors already built into AirPods Pro, AirPods Max, AirPods (3rd generation and later) and Beats Fit Pro. Calibrate once while sitting tall. When your head drifts too far forward (slouching) **or too far back (lounging)** and stays there, you get a gentle notification. Return to good posture and the menu bar icon turns green again.

- **Green seated figure** in the menu bar: you are sitting tall
- **Red seated figure**: you are slouching forward or leaning too far back
- Catches both directions: forward slouch and backward lounge, each with its own threshold
- Notifications tuned to nudge, not nag: a 10 second grace period and a 60 second cooldown between alerts
- Four sensitivity presets, from relaxed (18°) to maximum (5°)
- An ambient pill that hugs your MacBook notch and glows your posture color
- 100% on-device. No analytics, no network calls, no data collection of any kind.

## Free vs Pro

| | Free | Pro |
|---|:---:|:---:|
| Live posture monitoring & alerts | ✓ | ✓ |
| Menu bar + notch indicator | ✓ | ✓ |
| Sensitivity presets | ✓ | ✓ |
| Posture history & trends | | ✓ |
| CSV export of your stats | | ✓ |
| Custom sensitivity threshold | | ✓ |
| Notch size customization | | ✓ |

Pro unlocks with a license key that is verified **offline** — nothing leaves your Mac. Open the menu → **Unlock Pro…** to paste a key or buy one. Everything in the free tier stays free.

## Install

One line:

```bash
curl -fsSL https://raw.githubusercontent.com/KaranSud/slouchguard/main/scripts/install.sh | bash
```

Then allow Motion & Fitness and notification access, put in your AirPods, click the menu bar icon, and hit **Calibrate** while sitting the way you want to sit. Setup takes about 15 seconds.

**Requirements:** macOS 14 or later on Apple Silicon, plus AirPods Pro, AirPods Max, AirPods (3rd gen or later), or Beats Fit Pro. Regular Bluetooth headphones do not expose motion data.

Prefer manual? Grab `SlouchGuard.zip` from [Releases](https://github.com/KaranSud/slouchguard/releases), unzip into `/Applications`, right-click the app and choose Open.

## How it works

Apple ships a head tracking API (`CMHeadphoneMotionManager`) that streams pitch, roll and yaw from supported AirPods at about 25Hz. SlouchGuard smooths that stream, compares your head pitch against your calibrated baseline, and runs a small state machine:

1. Head drifts past your threshold: the icon turns red.
2. Stay there past the grace period: one notification fires.
3. Sit back up: the app logs a correction and the icon turns green.

A cooldown stops it from nagging you twice in the same minute, and hysteresis around the threshold stops the icon from flickering at the boundary.

Stats are written as one human readable JSON file per day in `~/Library/Application Support/SlouchGuard/stats/`, which is what makes the Claude Code skill below possible.

## Claude Code skill

If you use [Claude Code](https://claude.com/claude-code), SlouchGuard ships with a skill that turns Claude into the front end:

```bash
mkdir -p ~/.claude/skills && cp -R skill/slouchguard ~/.claude/skills/
```

Then, in any Claude Code session:

- *"Install SlouchGuard"* runs the installer for you
- *"How has my posture been today?"* reads your local stats and gives you the honest answer

## Menu reference

| Item | What it does |
|---|---|
| Calibrate | Records your good posture as the baseline (sit the way you sit when you sit well) |
| Pause / Resume | Stops and restarts monitoring |
| Sensitivity | Low 18° · Medium 12° · High 8° · Maximum 5° · Custom (Pro) |
| Notch Indicator | Always show · Only with Claude Code · Hidden · Size (Pro) |
| Posture History… | Trends, daily chart and CSV export (Pro) |
| Start at Login | Registers SlouchGuard as a login item |
| Unlock Pro… | Paste a license key or buy Pro |
| Today's line | Live posture score, slouch count and minutes slouched |

### Notch indicator

An ambient pill hugs your MacBook notch and glows your posture color: green sitting tall, red slouching. Hover it to see your live status and today's score. It appears when the app is running and goes away when you quit. Set it to **Only with Claude Code** and it appears just while Claude Code (or the Claude app) is your active window — pair that with **Start at Login** to have it quietly show up whenever you sit down to code, including full screen.

## Privacy

Everything runs and stays on your Mac. SlouchGuard makes zero network requests. There is no telemetry, no account, and no cloud. The stats files are plain JSON you can read, back up, or delete anytime. Delete `~/Library/Application Support/SlouchGuard/` and it is like the app was never there.

## FAQ

**macOS says the app is from an unidentified developer.**
SlouchGuard is ad-hoc signed rather than notarized. The install script clears the quarantine flag for you automatically. If you installed manually, right-click the app and choose Open once.

**Does it work with regular Bluetooth headphones?**
No. Only Apple and Beats models with the H1/H2 chip expose head motion: AirPods Pro, AirPods Max, AirPods 3rd gen and later, Beats Fit Pro.

**Is it Apple Silicon only?**
The current release binary targets Apple Silicon Macs (macOS 14+).

**The menu says "Head tracking paused — AirPods mic in use?"**
Apple disables AirPods head-motion whenever the AirPods are acting as a microphone (a call, dictation, or any app holding mic input), and it switches them into headset mode. SlouchGuard detects this and pauses cleanly; it resumes on its own once the mic is released. To keep tracking rock-solid during calls, set your Mac's audio **input** to the built-in microphone and leave **output** on the AirPods.

**Does it drain my AirPods battery?**
Head tracking uses the same sensor pipeline as Spatial Audio. The impact is minor, and you can Pause monitoring anytime from the menu.

**My alerts fire too often or not often enough.**
Change the Sensitivity preset. Low waits for a deep 18° slump, Maximum flags a 5° drift. Recalibrate whenever your setup changes, like a new chair or monitor height.

## License

SlouchGuard is proprietary software, free to use with an optional paid Pro upgrade. See [LICENSE](LICENSE). It is not open source.
