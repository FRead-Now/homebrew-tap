class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.4.1"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.1/fread-tools-0.4.1-darwin-arm64.tar.gz"
      sha256 "4e400b4686f0be9a40018d835ef0eb5cd9261588f89a5ac27caabb84d1b92bbd"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.1/fread-tools-0.4.1-darwin-amd64.tar.gz"
      sha256 "9379b1e40909c297bcb8000321ce8d362a5debd86c89b6c3eab21661c805a1ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.1/fread-tools-0.4.1-linux-arm64.tar.gz"
      sha256 "111db942c3066fa54d57e411e0eb2fbeed7154a107334bfbda0b79112b57989c"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.1/fread-tools-0.4.1-linux-amd64.tar.gz"
      sha256 "21f5254324d2dd4bd8e8927b52916caf11e769fb8755f215888642c06201b462"
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
