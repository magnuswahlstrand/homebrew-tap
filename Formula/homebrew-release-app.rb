class HomebrewReleaseApp < Formula
  desc "Test CLI for exercising Homebrew releases"
  homepage "https://github.com/magnuswahlstrand/homebrew-app"
  url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.2/homebrew-release-app_0.1.2_darwin_arm64.tar.gz"
  version "0.1.2"
  sha256 "6f8a6018f7c5eb15f41762282ca77f710538a9d3d22addde1d6480b2d50dd88a"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.2/homebrew-release-app_0.1.2_darwin_arm64.tar.gz"
      sha256 "6f8a6018f7c5eb15f41762282ca77f710538a9d3d22addde1d6480b2d50dd88a"
    end
    on_intel do
      url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.2/homebrew-release-app_0.1.2_darwin_amd64.tar.gz"
      sha256 "f5ff97563237a838ca2e250a12b4df971b8a40740a732410c8f4a32decd93f65"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.2/homebrew-release-app_0.1.2_linux_arm64.tar.gz"
      sha256 "ed5cdb803a533a4904c6554653c28ce680e2d773b90b2c4d44cf2f5dead2de56"
    end
    on_intel do
      url "https://github.com/magnuswahlstrand/homebrew-app/releases/download/v0.1.2/homebrew-release-app_0.1.2_linux_amd64.tar.gz"
      sha256 "6e547f19a9d719fb57ef961657429f019146058bbfa4bb0e4360c7ce56c85536"
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
