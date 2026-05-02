class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/multi-claude"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.1/claws-aarch64-apple-darwin.tar.xz"
      sha256 "f196d457509aca6561476d95c533aa848751df63623b34f9fc51a8317aa33ecc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.1/claws-x86_64-apple-darwin.tar.xz"
      sha256 "e5f98fef9977dd9b58cf49c30ac59ec0b6a959a5764256ed292d15f88bc8289c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.1/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4d96766947e2c269598a79522a716e1391c67832af98b26b454abca1028080d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.1/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50db4d54383058f1db24d6526122a34da9e6660e9d676ff2cb815c8566f59346"
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
