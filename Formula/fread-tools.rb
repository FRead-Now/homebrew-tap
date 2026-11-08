class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.3.0"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.3.0/fread-tools-0.3.0-darwin-arm64.tar.gz"
      sha256 "9e45b9adf8864f78959cfdf71c2f670c23ed7c389fe76baeb4fa9d035c698c67"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.3.0/fread-tools-0.3.0-darwin-amd64.tar.gz"
      sha256 "961b33f767b2c01d3806c5c59d056dade04e1dc946a919a842ed1a1a475de1cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.3.0/fread-tools-0.3.0-linux-arm64.tar.gz"
      sha256 "b60497fdfa929f6fdd5b3b91edd5332ce45331a73b400f765e9e251ea5accabd"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.3.0/fread-tools-0.3.0-linux-amd64.tar.gz"
      sha256 "448a58c3e821957242af9ffef256d2a3c40f301b71f2de59472addd4472d1f95"
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
