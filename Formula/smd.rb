class Smd < Formula
  desc "A minimalistic  Markdown renderer for the terminal with syntax highlighting, emoji support, and image rendering"
  homepage "https://github.com/guilhermeprokisch/smd"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.5/smd-aarch64-apple-darwin.tar.xz"
      sha256 "21a7be3f225710b5d2b482dcf043f3a174122d653f6ded61c2d190ef00795fdc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.5/smd-x86_64-apple-darwin.tar.xz"
      sha256 "8e545ab0df22f77af9a168140180e3f56ff3ace3792ce662562fb6aff2da2b0a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/guilhermeprokisch/smd/releases/download/v0.2.5/smd-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "dff14cb5734a1aa5f6ff834207b9776113a8e305877cb94de91361111eec6947"
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
