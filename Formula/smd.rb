class Smd < Formula
  desc "A minimalistic  Markdown renderer for the terminal with syntax highlighting, emoji support, and image rendering"
  homepage "https://github.com/guilhermeprokisch/smd"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.6/smd-aarch64-apple-darwin.tar.xz"
      sha256 "1029e3ff9d1aefe722105f098c87e864e403996a946e9144eab78b06812b68ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.6/smd-x86_64-apple-darwin.tar.xz"
      sha256 "fe651266e7a20a5e7f21ce59b788821e272e205cb7e45cdea7f9a681b3c2ffd3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.6/smd-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "91d62ccf2ee259c9c2dfd3f02e221606efe40e08f27c870913ed3b07a9f0cbfb"
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
