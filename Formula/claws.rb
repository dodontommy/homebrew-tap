class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/claws"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.5/claws-aarch64-apple-darwin.tar.xz"
      sha256 "c23501c6570b1a972d1cb8677338884fe79102d359a4a27a6c7f057ff694040d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.5/claws-x86_64-apple-darwin.tar.xz"
      sha256 "4165305406a9ba920ee97d15f6ac50ccedd0ebf3c0e2fd9fdaac07248d4e7ced"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.5/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d736a7666888e3d15f936c11d212e68d3da01f6ada811ef8cca8a7ae577511c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.5/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a9c8d89044beb012d11fd935ddab9714de187948bab8c703294f8de8b2788ff7"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "claws" if OS.mac? && Hardware::CPU.arm?
    bin.install "claws" if OS.mac? && Hardware::CPU.intel?
    bin.install "claws" if OS.linux? && Hardware::CPU.arm?
    bin.install "claws" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
