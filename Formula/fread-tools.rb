class FreadTools < Formula
  desc "FRead's editor tools: the ingest commands, fread-admin and fux snippets"
  homepage "https://github.com/FRead-Now/fread-tools"
  version "0.4.0"

  on_macos do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.0/fread-tools-0.4.0-darwin-arm64.tar.gz"
      sha256 "1e04c6856f62aff31ab9ad063a19504212e4be3e62ad0f464c073aea20a924c4"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.0/fread-tools-0.4.0-darwin-amd64.tar.gz"
      sha256 "8f95e84b573aa8c42f0fcd7f9934bba0bce2f57477366a295688665740cd740b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.0/fread-tools-0.4.0-linux-arm64.tar.gz"
      sha256 "9045a6394ef3c3e131919bec153f38e5fd28a5e7ba302a1380373520e1486feb"
    end
    on_intel do
      url "https://github.com/FRead-Now/fread-tools/releases/download/v0.4.0/fread-tools-0.4.0-linux-amd64.tar.gz"
      sha256 "3d55a145974777fa78afc08d663054a3ff5e0f8f07009716f01c103cc08dae75"
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
