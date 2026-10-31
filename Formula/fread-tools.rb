class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.1.3"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.3/fread-tools-0.1.3-darwin-arm64.tar.gz"
      sha256 "ca2433cf3369c13f19b6f845aee07100fe3f4d1db0b3f8a0d444be37f9f7237f"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.3/fread-tools-0.1.3-darwin-amd64.tar.gz"
      sha256 "c93adddefd84d1a0d7bfc51d7cd336866883efb3907c28488ce3547dc4670788"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.3/fread-tools-0.1.3-linux-arm64.tar.gz"
      sha256 "8511cb42939ccfdf13685f0c7762814d483318a19658a97eb9b576f9f91a91d2"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.3/fread-tools-0.1.3-linux-amd64.tar.gz"
      sha256 "c5038a2ae00a7365d098dc2bc8de66ca351bde5de71d2a277edb78a863e338b0"
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
      These tools serve the working catalog at schema 53 and need fux 0.7.0
      or later for FRead's snippet library. They reach the catalog only with the
      database credentials and network access the operator gives you.
    EOS
  end

  # The binaries stamp the tag, with its leading v; the formula version is the
  # bare X.Y.Z Homebrew compares, hence the explicit "v".
  test do
    %w[ingest-gutenberg-html ingest-override ingest-work ingest-notes ingest-audiobook fread-admin].each do |tool|
      assert_equal "#{tool} v#{version} (schema 53)", shell_output("#{bin}/#{tool} --version").strip
    end
    assert_path_exists share/"fux/snippets.d/fread.xml"
    # fux 0.7 lists every library it loaded, and exits 1 on any file's problem:
    # FRead's must be among them, found where Homebrew linked it.
    snippets = shell_output("#{Formula["marcelinto/tap/fux"].opt_bin}/fux --snippets")
    assert_match %r{share/fux/snippets\.d/fread\.xml: \d+ snippets}, snippets
  end
end
