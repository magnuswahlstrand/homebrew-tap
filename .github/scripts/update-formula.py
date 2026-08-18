#!/usr/bin/env python3
import hashlib
import sys
import tempfile
import urllib.request

APP_REPO = "magnuswahlstrand/homebrew-app"
PROJECT = "homebrew-release-app"
SUFFIXES = ["darwin_arm64", "darwin_amd64", "linux_arm64", "linux_amd64"]
FORMULA = "Formula/homebrew-release-app.rb"


def sha256_of(url):
    with urllib.request.urlopen(url) as resp, tempfile.TemporaryFile() as fh:
        digest = hashlib.sha256()
        while True:
            chunk = resp.read(1 << 20)
            if not chunk:
                break
            digest.update(chunk)
            fh.write(chunk)
        return digest.hexdigest()


def formula_for(version, digests):
    archive = lambda suffix: (
        f"https://github.com/{APP_REPO}/releases/download/v{version}/"
        f"{PROJECT}_{version}_{suffix}.tar.gz"
    )
    return f'''class HomebrewReleaseApp < Formula
  desc "Test CLI for exercising Homebrew releases"
  homepage "https://github.com/{APP_REPO}"
  url "{archive("darwin_arm64")}"
  version "{version}"
  sha256 "{digests["darwin_arm64"]}"
  license "MIT"

  on_macos do
    on_arm do
      url "{archive("darwin_arm64")}"
      sha256 "{digests["darwin_arm64"]}"
    end
    on_intel do
      url "{archive("darwin_amd64")}"
      sha256 "{digests["darwin_amd64"]}"
    end
  end

  on_linux do
    on_arm do
      url "{archive("linux_arm64")}"
      sha256 "{digests["linux_arm64"]}"
    end
    on_intel do
      url "{archive("linux_amd64")}"
      sha256 "{digests["linux_amd64"]}"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "homebrew-release-app-#{{os}}-#{{arch}}" => "homebrew-release-app"
  end

  test do
    assert_match "homebrew-release-app", shell_output("#{{bin}}/homebrew-release-app --version")
  end
end
'''


def main():
    version = sys.argv[1].lstrip("v")
    digests = {}
    for suffix in SUFFIXES:
        url = (
            f"https://github.com/{APP_REPO}/releases/download/v{version}/"
            f"{PROJECT}_{version}_{suffix}.tar.gz"
        )
        digests[suffix] = sha256_of(url)
    with open(FORMULA, "w") as fh:
        fh.write(formula_for(version, digests))
    print(f"updated {FORMULA} to {version}")


if __name__ == "__main__":
    main()