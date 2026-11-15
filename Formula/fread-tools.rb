class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.3.1"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.3.1/fread-tools-0.3.1-darwin-arm64.tar.gz"
      sha256 "76a4b8fb09b8f4ba078aafec3eca3831a8aaec77f0a32f16c8bd9e63ef164519"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.3.1/fread-tools-0.3.1-darwin-amd64.tar.gz"
      sha256 "c36d7d81bfa31f5f164068c4486abc0f18e4636e1e9190f3b8a65010654a5685"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.3.1/fread-tools-0.3.1-linux-arm64.tar.gz"
      sha256 "c7b83b1bea75b52a506341f4ba6eedcbf4b121c758399a24216e171a5c03f296"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.3.1/fread-tools-0.3.1-linux-amd64.tar.gz"
      sha256 "98b78f1b1f069adeccc14ed052356f11ae4b934a221487b532dfd3a85276e86c"
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
