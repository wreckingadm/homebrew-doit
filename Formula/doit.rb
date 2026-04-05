class Doit < Formula
  desc "High-efficiency personal task manager"
  homepage "https://github.com/wreckingadm/doit"
  url "https://github.com/wreckingadm/homebrew-doit/releases/download/main-app-v0.8.5/doit-v0.8.0-6bbe256-darwin-arm64.tar.gz"
  sha256 "560a701e87ab72b068b1d045c5ff208e349c865adcf6281f84fba11d8c575b8b"
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
