# Custom Download Strategy for Private GitHub Releases
class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  def _fetch
    @url = @resource.url
    @filename = @resource.mirrors.first || File.basename(@url)
    
    # Get the asset ID from the tag and filename
    # This requires the HOMEBREW_GITHUB_API_TOKEN to be set
    ohai "Determining asset ID for #{@filename}..."
    
    # Extract owner, repo, tag from the URL
    # URL format: https://github.com/OWNER/REPO/releases/download/TAG/FILENAME
    parts = @url.split("/")
    owner = parts[3]
    repo = parts[4]
    tag = parts[7]
    
    # Use gh or curl to find the asset ID
    asset_id = `curl -s -H "Authorization: token #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}" \
                "https://api.github.com/repos/#{owner}/#{repo}/releases/tags/#{tag}" | \
                grep -B 1 "name\": \"#{@filename}\"" | grep "\"id\":" | head -n 1 | awk '{print }' | sed 's/,//'`.strip

    if asset_id.empty?
      odie "Could not find asset ID for #{@filename} in release #{tag}. Make sure HOMEBREW_GITHUB_API_TOKEN is set and has repo scope."
    end

    @url = "https://api.github.com/repos/#{owner}/#{repo}/releases/assets/#{asset_id}"
    
    # Now download using the API URL and the correct header
    curl_download @url, "-H", "Authorization: token #{ENV["HOMEBREW_GITHUB_API_TOKEN"]}", "-H", "Accept: application/octet-stream", to: temporary_path
  end
end

class Doit < Formula
  desc "High-efficiency personal task manager"
  homepage "https://github.com/wreckingadm/doit"
  url "https://github.com/wreckingadm/doit/releases/download/main-app-v0.8.2/doit-v0.8.0-f1baf67-darwin-arm64.tar.gz", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "22bfd0d113a7a8de597aced9ae5b9a85899034d2cecbb4a4780662633f8807a6"
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
