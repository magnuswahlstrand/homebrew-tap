# homebrew-tap

Homebrew tap for [magnuswahlstrand/homebrew-app](https://github.com/magnuswahlstrand/homebrew-app),
which publishes releases of the `homebrew-release-app` CLI.

## Install

```sh
brew tap magnuswahlstrand/tap
brew install homebrew-release-app
```

## Release flow

1. In `magnuswahlstrand/homebrew-app`, build the CLI for all four targets and
   upload a tarball per target to a GitHub release named `v<version>`:

   - `homebrew-release-app_<version>_darwin_arm64.tar.gz`
   - `homebrew-release-app_<version>_darwin_amd64.tar.gz`
   - `homebrew-release-app_<version>_linux_arm64.tar.gz`
   - `homebrew-release-app_<version>_linux_amd64.tar.gz`

   Each tarball must contain the binary at its root, named
   `homebrew-release-app-darwin-arm64` (or `...-darwin-amd64`,
   `...-linux-arm64`, `...-linux-amd64`). The formula renames it on install.

2. Trigger the formula update in this repo by dispatching a
   `repository_dispatch` event with `event_type: release` and a client payload
   containing the tag:

   ```yaml
   - name: Dispatch formula update
     run: |
       gh api repos/magnuswahlstrand/homebrew-tap/dispatches \
         -f event_type=release \
         -f "client_payload[tag]=${{ github.ref_name }}"
   ```

   The dispatch must be sent with a token that can read the tap repo, e.g. a
   PAT stored as a secret in `homebrew-app`.

3. The [update-formula workflow](.github/workflows/update-formula.yml) downloads
   the four tarballs, recomputes their sha256, bumps the `version` field in
   [Formula/homebrew-release-app.rb](Formula/homebrew-release-app.rb), and
   commits the change to `main`.

## Manual update

Update the formula by hand for a new release:

```sh
brew bump-formula-pr --no-audit \
  --url https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.1/homebrew-release-app_0.1.1_darwin_arm64.tar.gz \
  homebrew-release-app
```

or run the update script directly (it downloads all four tarballs and fills in
their sha256):

```sh
python3 .github/scripts/update-formula.py v0.1.1
```

## Test locally

```sh
brew install --formula Formula/homebrew-release-app.rb
brew test Formula/homebrew-release-app.rb
brew audit --formula Formula/homebrew-release-app.rb
```
