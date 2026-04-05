class Doit < Formula
  desc "High-efficiency personal task manager"
  homepage "https://github.com/wreckingadm/doit"
  url "https://github.com/wreckingadm/doit/releases/download/main-app-v0.8.1/doit-v0.8.0-c76b39b-darwin-arm64.tar.gz"
  sha256 "6eef99654ea6e1e94ecdf0524854ff81ab49d7c1eba69a949c1ad3a8b810c7cd"
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
