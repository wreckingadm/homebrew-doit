class Doit < Formula
  desc "High-efficiency personal task manager"
  homepage "https://github.com/wreckingadm/doit"
  url "https://github.com/wreckingadm/doit/releases/download/v1.0.3/doit-v1.0.3-c58e6a6-darwin-arm64.tar.gz"
  sha256 "79cca139be3f5fe3a4d69b9a5e9322518906f120bae5fb7df3cc5368b6af2105"
  version "1.0.3"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/doit"
  end

  test do
    system "#{bin}/doit", "--version"
  end
end
