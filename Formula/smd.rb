class Smd < Formula
  desc "A minimalistic  Markdown renderer for the terminal with syntax highlighting, emoji support, and image rendering"
  homepage "https://github.com/guilhermeprokisch/smd"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.0/smd-aarch64-apple-darwin.tar.xz"
      sha256 "e1d0836c3e9fe73eea8742f36f630e372f27c3aa42c3082e1c718477379a5c79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.0/smd-x86_64-apple-darwin.tar.xz"
      sha256 "3322328204a01f70bc1814ee0d395f46307ecc94e0c929ffff9fa38ef38e9de3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.0/smd-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "acef7533d69f3c381979ecf078d1baeb34fa445b0fc6faf58193b862a8ccbe58"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "smd" if OS.mac? && Hardware::CPU.arm?
    bin.install "smd" if OS.mac? && Hardware::CPU.intel?
    bin.install "smd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
