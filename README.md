# apple-ai

Minimal Swift CLI that exposes Apple Foundation Models from the command line.

## Features

- Prompt the on-device Apple model from your terminal (`ai "..."`)
- Check model readiness with actionable diagnostics (`ai --model-info`)
- No network dependency for inference (uses on-device model)

## What it does

Runs prompts through `SystemLanguageModel.default` via `LanguageModelSession`:

```bash
ai "Who won World War II?"
```

Check readiness without sending a prompt:

```bash
ai --model-info
```

## Requirements

- macOS 26.0+
- Apple Intelligence-capable device
- Apple Intelligence enabled in System Settings
- Swift 6.3+ (Xcode 26 toolchain)

## Quick start

```bash
git clone <your-repo-url>
cd apple-ai
swift run ai --model-info
swift run ai "Who won World War II?"
```

## Build and run

```bash
swift build -c release
.build/release/ai "Who won World War II?"
```

Or run directly with SwiftPM:

```bash
swift run ai "Who won World War II?"
swift run ai --model-info
```

## Optional install as `ai`

```bash
ln -sf "$(pwd)/.build/release/ai" /usr/local/bin/ai
```

If `/usr/local/bin` is not in your `PATH`, add it (or symlink to another directory in your `PATH`).

## Install with Homebrew

After the tap is published:

```bash
brew tap hgenc/tap
brew install apple-ai
```

This project includes a release workflow that can notify your tap repository and
automatically update the formula URL and SHA256 on each GitHub release.

## CLI usage

```text
Usage:
  ai "<prompt>"
  ai <prompt words>
  ai --model-info
  ai --status
```

## Troubleshooting

If `ai --model-info` reports unavailable:

- `appleIntelligenceNotEnabled`: turn on Apple Intelligence in System Settings
- `modelNotReady`: keep Mac on Wi-Fi + power until model download finishes
- `deviceNotEligible`: Apple Intelligence currently requires Apple Silicon

## Contributing

Contributions are welcome. See `CONTRIBUTING.md`.

## Security

Please report vulnerabilities privately as described in `SECURITY.md`.

## License

MIT (`LICENSE`)