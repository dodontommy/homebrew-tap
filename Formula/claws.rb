class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/multi-claude"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.5/claws-aarch64-apple-darwin.tar.xz"
      sha256 "72df14fb0abd7a3b5ad4467c966483e4fe2416010864d9cf2766768dede37c12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.5/claws-x86_64-apple-darwin.tar.xz"
      sha256 "0dd107c0628a9713204ea09da1fbc3fc0a55a765acb493d230ce6a22d4485018"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.5/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ece8511e0d679a6bb888a86d3bab31a384122912cfe98c4475a503651ce090e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.5/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "611f2ed15bf53f3c8cf646c16f08a304ce455c24a99b19de77cf256f9be38ff3"
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
