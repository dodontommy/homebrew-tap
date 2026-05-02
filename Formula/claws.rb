class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/multi-claude"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.2/claws-aarch64-apple-darwin.tar.xz"
      sha256 "6d4df1dcc2c4917f4f594ab070c41617cd0364eb9ee0b26d87d454da5d40e690"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.2/claws-x86_64-apple-darwin.tar.xz"
      sha256 "6a0da083719f46e5180c0e09bb75461bb74adf69e5a875766c6a012475024077"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.2/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "175792277e8c4837a5b4d09e3135c09027c50634e0de31960db297cb7ce7583b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/multi-claude/releases/download/v0.1.2/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "007b330ba2ab9e3fe4b7fe2daf06402d1d75697aeef2ea224eb0ef9a13c4cc16"
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
