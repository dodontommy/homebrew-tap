class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/multi-claude"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.3/claws-aarch64-apple-darwin.tar.xz"
      sha256 "b91fd2ca59ed19699c9d74f550ab445ae59af965fc339f7284cc7e718821310d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.3/claws-x86_64-apple-darwin.tar.xz"
      sha256 "c0f935fb69b62b276bbe3ed2084ecaf3bc000503cce3bd28444fe9e9e6989db5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.3/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f97640aee34d3fe91407f69cfc4277a091b3402f704059820980aa168eb6838"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.3/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "607cd464d8ba75ff59db89ae15a8c6fd7b87c7707b57861ebf7751188d9f52fc"
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
