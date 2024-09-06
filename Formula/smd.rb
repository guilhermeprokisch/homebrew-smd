class Smd < Formula
  desc "A minimalistic  Markdown renderer for the terminal with syntax highlighting, emoji support, and image rendering"
  homepage "https://github.com/guilhermeprokisch/smd"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.3.1/smd-aarch64-apple-darwin.tar.xz"
      sha256 "51f46c708653cfc2ad4ef4f5fadcbe6f5b1544b0234a3c622e6ca047083e795e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.3.1/smd-x86_64-apple-darwin.tar.xz"
      sha256 "a064ce12cc68edca64d3641f0dbf66aa6c6523ead36336cc44f6137ee11440ca"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/smd/releases/download/v0.3.1/smd-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ae7bbae04d1ab13250b8870c9b81a4f40d1573bb3ccc419d08eb5e8a3fefd60c"
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
