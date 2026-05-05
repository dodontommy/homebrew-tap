class ClawsTui < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/claws-tui"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.0/claws-tui-aarch64-apple-darwin.tar.xz"
      sha256 "e4da71003c541dcaeafe8b2e976ba32540f00392ed99202a49a561e36fafdad4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.0/claws-tui-x86_64-apple-darwin.tar.xz"
      sha256 "d97b8b43396d838e5f127c68affe8384b5b1b52beee19e9ee75f863aecede9ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.0/claws-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2fd2f83122e38efd116cd8227b58431c9ab4167451d70a7d1b208bf5873e816c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.0/claws-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c7375a7596a69acabf3f1ecc0b1c0244e743c67f3c200393fef8800ee565241"
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
