class Doit < Formula
  desc "High-efficiency personal task manager"
  homepage "https://github.com/wreckingadm/doit"
  url "https://github.com/wreckingadm/homebrew-doit/releases/download/doit-cli-v0.12.1/doit-v0.12.1-9e89d43-darwin-arm64.tar.gz"
  sha256 "9d0f93aa11a293e6a52b61e57eee952c4d54b5bbb23e7143754c19c77503cdb5"
  version "0.12.1"

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
