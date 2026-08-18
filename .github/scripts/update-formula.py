#!/usr/bin/env python3
import hashlib
import re
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


def main():
    tag = sys.argv[1].lstrip("v")
    with open(FORMULA) as fh:
        text = fh.read()

    text = re.sub(
        r'(version ")[^"]*(")', rf"\g<1>{tag}\g<2>", text, count=1
    )

    for suffix in SUFFIXES:
        url = (
            f"https://github.com/{APP_REPO}/releases/download/v{tag}/"
            f"{PROJECT}_{tag}_{suffix}.tar.gz"
        )
        digest = sha256_of(url)
        text = re.sub(
            rf'(url "{url}"\s*\n\s*sha256 ")[0-9a-f]{{64}}(")',
            rf"\g<1>{digest}\g<2>",
            text,
        )

    with open(FORMULA, "w") as fh:
        fh.write(text)
    print(f"updated {FORMULA} to {tag}")


if __name__ == "__main__":
    main()
