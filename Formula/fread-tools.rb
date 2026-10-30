class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.1.2"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.2/fread-tools-0.1.2-darwin-arm64.tar.gz"
      sha256 "03ef880b791ac290b9866cc5ffd4d668733d64b32e07197b61c65a597a91671c"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.2/fread-tools-0.1.2-darwin-amd64.tar.gz"
      sha256 "000da3324103ab86494820f68e8ac1a1d31e9bed6467e77e1296719604c59f16"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.2/fread-tools-0.1.2-linux-arm64.tar.gz"
      sha256 "8c29a8092bdfdbcc7d58c4f64be941e9b13fe8b67150e4f7208bc98bfad2eff2"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.2/fread-tools-0.1.2-linux-amd64.tar.gz"
      sha256 "59bc6740b40d26ea1889d6c4cbe851113deacec7f0c75a6bec0b7e622921ce19"
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
