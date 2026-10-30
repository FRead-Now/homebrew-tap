class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.1.1"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.1/fread-tools-0.1.1-darwin-arm64.tar.gz"
      sha256 "883a63f5e958dc6a6315027a245caa8d54720dc1747e15fdb2f98472007a434b"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.1/fread-tools-0.1.1-darwin-amd64.tar.gz"
      sha256 "bb669518920bbc0922a4487c5a1fb420902c53d8cb56933108b6fa3c3f0d83f7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.1/fread-tools-0.1.1-linux-arm64.tar.gz"
      sha256 "c3ea068234a119bbb71c81e60e5816363050b921d085d0282498197531e18aee"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.1/fread-tools-0.1.1-linux-amd64.tar.gz"
      sha256 "10372cece2dc3e325f116ee42b17452770495a0697de8aed8ab3e54dc39a7149"
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
