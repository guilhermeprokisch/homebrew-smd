class Smd < Formula
  desc "A minimalistic  Markdown renderer for the terminal with syntax highlighting, emoji support, and image rendering"
  homepage "https://github.com/guilhermeprokisch/smd"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.1/smd-aarch64-apple-darwin.tar.xz"
      sha256 "43848795df7c74684365e003f535ec9c1c7c0cc798c1cdd031b20245443cd7ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.1/smd-x86_64-apple-darwin.tar.xz"
      sha256 "62f225514947ee149771ac2308b940ca84a9ef7f3495e5c40d90b312a5645cf8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.1/smd-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5c5ee524771605262cf95799f79ff9a2f38e14417705dd8cc065bbc5e1b33be8"
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
