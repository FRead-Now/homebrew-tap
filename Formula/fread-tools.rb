class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.0/fread-tools-0.1.0-darwin-arm64.tar.gz"
      sha256 "ccf12efde25dfff75c8336f06de2f8e5f4e27d2015dd8a29a6901ef77c49cbc2"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.0/fread-tools-0.1.0-darwin-amd64.tar.gz"
      sha256 "efcbab3cc87c873f59a1b15f98080d708da2aebbb5a7f064ac6e12ef3ebc9b11"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.0/fread-tools-0.1.0-linux-arm64.tar.gz"
      sha256 "9deefa06893154acb1f082911526d42e1e13e5b5b03b352bf13b62db0aad154f"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.1.0/fread-tools-0.1.0-linux-amd64.tar.gz"
      sha256 "766d6d987ee9e2b7b1a6b083b07f85e75e567137b97bcdac672f4c7afcffeef5"
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
