class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.4.2"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.2/fread-tools-0.4.2-darwin-arm64.tar.gz"
      sha256 "22fdfce299fed54a8da78d446ecf75452973eba62fba612876e0047b12767279"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.2/fread-tools-0.4.2-darwin-amd64.tar.gz"
      sha256 "5c0d6b068184aa2a864d3535ee64e146dc2c99806ed2bf09418ca320eed44319"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.2/fread-tools-0.4.2-linux-arm64.tar.gz"
      sha256 "b3d77ffb50f3c613318d7d3ccb5e47e34d0447ccae35335caad6e0bd0a9496d3"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.2/fread-tools-0.4.2-linux-amd64.tar.gz"
      sha256 "3543060069ccf0deb8a0d4ea628ed1f8160581feb971befdf735a014afac15f8"
    end
  end

  depends_on "marcelinto/tap/fux"

  def install
    bin.install Dir["bin/*"]
    (share/"fux/snippets.d").install "share/fux/snippets.d/fread.xml"
    doc.install "README.md", "THIRD-PARTY-NOTICES.md"
  end

  def caveats
    <<~EOS
      These tools serve the working catalog at schema 55 and need fux 0.7.0
      or later for FRead's snippet library. They reach the catalog only with the
      database credentials and network access the operator gives you.
    EOS
  end

  # The binaries stamp the tag, with its leading v; the formula version is the
  # bare X.Y.Z Homebrew compares, hence the explicit "v".
  test do
    %w[ingest-gutenberg-html ingest-override ingest-work ingest-notes ingest-audiobook fread-admin].each do |tool|
      assert_equal "#{tool} v#{version} (schema 55)", shell_output("#{bin}/#{tool} --version").strip
    end
    assert_path_exists share/"fux/snippets.d/fread.xml"
    # fux 0.7 lists every library it loaded, and exits 1 on any file's problem:
    # FRead's must be among them, found where Homebrew linked it.
    snippets = shell_output("#{Formula["marcelinto/tap/fux"].opt_bin}/fux --snippets")
    assert_match %r{share/fux/snippets\.d/fread\.xml: \d+ snippets}, snippets
  end
end
