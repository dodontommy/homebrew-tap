class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/multi-claude"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.4/claws-aarch64-apple-darwin.tar.xz"
      sha256 "bfec88dc49287529578feead63210c0b6e53faae353288827efc7f570aaf26ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.4/claws-x86_64-apple-darwin.tar.xz"
      sha256 "c02958caf51915117bcb60219b2a8ca1589f0d021544251fea84e5db99858041"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.4/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a703009f9235c8b7f5c96fd8d181a9f6beff6b4567d6bd6753eda38f86da94aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.4/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "79b2ad4bee96f6438152c023c297c90bd1b583d9010f86bea9f604c46b70ecc4"
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
