class Doit < Formula
  desc "High-efficiency personal task manager"
  homepage "https://github.com/wreckingadm/doit"
  url "https://github.com/wreckingadm/doit/releases/download/v1.0.3/doit-v1.0.3-c1cb960-darwin-arm64.tar.gz"
  sha256 "d2b55ad7aad6a823f0eef19073f48127a8686870f606384704d212c9c5d4901f"
  version "1.0.3"

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
