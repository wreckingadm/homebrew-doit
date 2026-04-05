class Doit < Formula
  desc "High-efficiency personal task manager"
  homepage "https://github.com/wreckingadm/doit"
  url "https://github.com/wreckingadm/doit/releases/download/doit-cli-v0.8.0/doit-v0.8.0-ab8ebcb-darwin-arm64.tar.gz"
  sha256 "5ab9c0440a13492059486bd37fe8fa1edcac70f882fd4e1dcd8bf1108ca42b1d"
  version "0.8.0"

  def install
    libexec.install Dir["*"]
    # Oclif tarballs often have a single top-level directory named after the app
    # We try to symlink from the expected bin path
    if File.exist?(libexec/"bin/doit")
      bin.install_symlink libexec/"bin/doit"
    else
      # If it's nested (e.g. libexec/doit/bin/doit)
      bin.install_symlink Dir["#{libexec}/*/bin/doit"].first
    end
  end

  test do
    system "#{bin}/doit", "--version"
  end
end
