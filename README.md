# apple-ai

Minimal Swift CLI that exposes Apple Foundation Models from the command line.

## Features

- Prompt the on-device Apple model from your terminal (`ai "..."`)
- Check model readiness with actionable diagnostics (`ai --model-info`)
- No network dependency for inference (uses on-device model)

## What it does

Runs prompts through `SystemLanguageModel.default` via `LanguageModelSession`:

```bash
ai "Summarize why on-device AI can improve privacy in 3 bullet points."
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
brew tap hasangenc0/tap
brew install ai
```

Then choose the mode you want:

- Check model readiness and setup status:
  ```bash
  ai --model-info
  ```
- Ask a single one-shot question:
  ```bash
  ai "Summarize why on-device AI can improve privacy in 3 bullet points."
  ```
- Start an interactive conversation:
  ```bash
  ai --interactive
  ```
- Start interactive mode with a first message:
  ```bash
  ai "What is 2+2?" --interactive
  ```

## Build from source

```bash
git clone https://github.com/hasangenc0/apple-ai.git
cd apple-ai
swift run ai --model-info
swift run ai "Summarize why on-device AI can improve privacy in 3 bullet points."
```

## Build and run (release binary)

```bash
swift build -c release
.build/release/ai "Summarize why on-device AI can improve privacy in 3 bullet points."
```

Or run directly with SwiftPM:

```bash
swift run ai "Summarize why on-device AI can improve privacy in 3 bullet points."
swift run ai --model-info
```

## Optional install as `ai`

```bash
ln -sf "$(pwd)/.build/release/ai" /usr/local/bin/ai
```

If `/usr/local/bin` is not in your `PATH`, add it (or symlink to another directory in your `PATH`).

## CLI usage

```text
Usage:
  ai "<prompt>"
  ai <prompt words>
  ai --model-info
  ai --status
  ai --interactive
  ai -i
  ai "<prompt>" --interactive
```

## Troubleshooting

If `ai --model-info` reports unavailable:

- `appleIntelligenceNotEnabled`: turn on Apple Intelligence in System Settings
- `modelNotReady`: keep Mac on Wi-Fi + power until model download finishes
- `deviceNotEligible`: Apple Intelligence currently requires Apple Silicon

## Contributing

Contributions are welcome. See [Contributing](./CONTRIBUTING.md).

## Security

Please report vulnerabilities privately as described in [Security](./SECURITY.md).

## License

[MIT License](./LICENSE)