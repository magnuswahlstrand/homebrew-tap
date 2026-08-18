class HomebrewReleaseApp < Formula
  desc "Test CLI for exercising Homebrew releases"
  homepage "https://github.com/magnuswahlstrand/homebrew-app"
  url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.1/homebrew-release-app_0.1.1_darwin_arm64.tar.gz"
  version "0.1.2"
  sha256 "d39d9507afcf073775a8b45fb017df3452f21b8a5d984ca8984b674266cc0d11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.1/homebrew-release-app_0.1.1_darwin_arm64.tar.gz"
      sha256 "d39d9507afcf073775a8b45fb017df3452f21b8a5d984ca8984b674266cc0d11"
    end
    on_intel do
      url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.1/homebrew-release-app_0.1.1_darwin_amd64.tar.gz"
      sha256 "cab8b54cee7d711d6b4620ccb03194113044baf18b383dec12d457bb3e849412"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.1/homebrew-release-app_0.1.1_linux_arm64.tar.gz"
      sha256 "a210442078f019239da7d1b568cd1f8df1bd87f0fe74ee72fcebdf9c2cf6de38"
    end
    on_intel do
      url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.1/homebrew-release-app_0.1.1_linux_amd64.tar.gz"
      sha256 "9d250e76ae205100106b3d4c307a7b263edd2fc37fc0f7d5cb634f7cbc52fec8"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "homebrew-release-app-#{os}-#{arch}" => "homebrew-release-app"
  end

  test do
    assert_match "homebrew-release-app", shell_output("#{bin}/homebrew-release-app --version")
  end
end
