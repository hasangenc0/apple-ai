# Contributing

Thanks for your interest in improving `apple-ai`.

## Development setup

1. Install Xcode 26 (or newer) and Swift 6.3.
2. Clone the repository.
3. Build and test:

```bash
swift build
swift test
```

## Local usage

```bash
swift run ai --model-info
swift run ai "Write a haiku about on-device AI."
```

## Pull request checklist

- Keep changes focused and small when possible.
- Add or update tests for behavior changes.
- Update docs (`README.md` or other docs) when behavior or flags change.
- Make sure `swift build` and `swift test` pass locally.

## Reporting bugs and requesting features

Please use GitHub Issues and include:

- macOS version
- Xcode and Swift version
- command run
- full output/error text
