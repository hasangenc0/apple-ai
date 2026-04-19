# Homebrew release automation

This repository can notify a tap repo when a release is published.

## In `apple-ai` (source repo)

Set these GitHub Actions secrets:

- `HOMEBREW_TAP_REPO`: repository slug of your tap, e.g. `hgenc/homebrew-tap`
- `HOMEBREW_TAP_TOKEN`: GitHub token that can dispatch and write to the tap repo

Then publish a release (for example, `v0.1.0`).

The workflow `.github/workflows/dispatch-homebrew-tap.yml` sends a
`repository_dispatch` event to the tap repo with:

- `version`: release tag (e.g. `v0.1.0`)
- `repo`: source repo slug (e.g. `hgenc/apple-ai`)

## In `homebrew-tap`

The workflow `.github/workflows/update-apple-ai-formula.yml`:

1. Downloads `https://github.com/<source>/archive/refs/tags/<version>.tar.gz`
2. Computes SHA256
3. Updates `Formula/apple-ai.rb` (`url` and `sha256`)
4. Commits and pushes the formula change

You can also run it manually from Actions using `workflow_dispatch`.