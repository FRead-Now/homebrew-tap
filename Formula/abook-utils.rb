class AbookUtils < Formula
  include Language::Python::Virtualenv

  desc "FRead's audiobook tool: find, fetch, trim and align LibriVox recordings"
  homepage "https://github.com/FRead-Now/abook-utils"
  url "https://github.com/FRead-Now/abook-utils/releases/download/v0.2.1/abook-utils-0.2.1.tar.gz"
  sha256 "0d748321755f0f0f8218881a8cb9706d6d238a7ad0ea3b2cd09141473ea8ed5c"

  depends_on "uv" => :build
  depends_on arch: :arm64
  depends_on macos: :sonoma
  depends_on "ffmpeg"
  depends_on "python@3.14"

  preserve_rpath

  def install
    python = libexec/"bin/python"
    virtualenv_create(libexec, "python3.14", system_site_packages: false)
    system "uv", "pip", "install", "--python", python, "--require-hashes", "--compile-bytecode",
           "-r", "requirements.txt"
    system "uv", "pip", "install", "--python", python, "--no-deps", "--compile-bytecode",
           Dir["abook_utils-*.whl"].first

    # find, not glob: a glob's ** skips the wheels' hidden .dylibs/ folders.
    libexec.find do |lib|
      next if lib.symlink? || !lib.file? || [".dylib", ".so"].exclude?(lib.extname) || !lib.dylib?

      id = lib.dylib_id
      next if id.nil? || id.start_with?("@rpath/")

      system "install_name_tool", "-id", "@rpath/#{File.basename(id)}", lib
      system "codesign", "--force", "--sign", "-", lib
    end

    # abook runs ffmpeg and ffprobe by name: these, whatever PATH holds.
    (bin/"abook").write_env_script libexec/"bin/abook", PATH: "#{Formula["ffmpeg"].opt_bin}:$PATH"
    doc.install "README.md", "requirements.txt"
  end

  def caveats
    <<~EOS
      abook downloads its speech models on first use into ~/.cache: Whisper base.en
      (about 150 MB) for strip-intro, then whisper-large-v3-turbo (1.6 GB) and
      torchaudio's MMS_FA (1.2 GB) for align. They stay there across upgrades.
    EOS
  end

  test do
    assert_equal "abook v#{version} (fread-audio-alignment 0.1)", shell_output("#{bin}/abook --version").strip
    # Every engine imports from the keg's environment.
    system libexec/"bin/python", "-c", "import torch, torchaudio, mlx_whisper, faster_whisper, mutagen"
    # ffmpeg and ffprobe reach abook through the env script.
    system Formula["ffmpeg"].opt_bin/"ffmpeg", "-v", "error", "-f", "lavfi", "-i", "sine=duration=2",
           testpath/"tone.mp3"
    assert_match(/duration \d\.\d\ds/, shell_output("#{bin}/abook probe #{testpath}/tone.mp3"))
  end
end
