class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.2.0/fread-tools-0.2.0-darwin-arm64.tar.gz"
      sha256 "11a48eb7aef4128c2545b2b8914de38d0dc4a46160124c1ced034931501be5f5"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.2.0/fread-tools-0.2.0-darwin-amd64.tar.gz"
      sha256 "229f911fbf7dcea164b99e116d880f1c2c2e1797fceee70b1a0cdbe07adb4352"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.2.0/fread-tools-0.2.0-linux-arm64.tar.gz"
      sha256 "1e5b3629803ce064eb96ee722cba58f44172052cc34354577c526d078f8756a9"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.2.0/fread-tools-0.2.0-linux-amd64.tar.gz"
      sha256 "c782953420bfc7d6931859873fd6e71bd434a8015331ebdf4818236372f78df6"
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
      These tools serve the working catalog at schema 54 and need fux 0.7.0
      or later for FRead's snippet library. They reach the catalog only with the
      database credentials and network access the operator gives you.
    EOS
  end

  # The binaries stamp the tag, with its leading v; the formula version is the
  # bare X.Y.Z Homebrew compares, hence the explicit "v".
  test do
    %w[ingest-gutenberg-html ingest-override ingest-work ingest-notes ingest-audiobook fread-admin].each do |tool|
      assert_equal "#{tool} v#{version} (schema 54)", shell_output("#{bin}/#{tool} --version").strip
    end
    assert_path_exists share/"fux/snippets.d/fread.xml"
    # fux 0.7 lists every library it loaded, and exits 1 on any file's problem:
    # FRead's must be among them, found where Homebrew linked it.
    snippets = shell_output("#{Formula["marcelinto/tap/fux"].opt_bin}/fux --snippets")
    assert_match %r{share/fux/snippets\.d/fread\.xml: \d+ snippets}, snippets
  end
end
