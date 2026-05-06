class ClawsTui < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/claws-tui"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.2/claws-tui-aarch64-apple-darwin.tar.xz"
      sha256 "1d8bbe984cc24c30134909461bf160ad6a3e592fd01d38c7251e7baf8fa78856"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.2/claws-tui-x86_64-apple-darwin.tar.xz"
      sha256 "2731c11fe330520536faf3d6843444b228a27bbc676c9f2fc8b636b72ed03478"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.2/claws-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "783a9f5331d69e26bad79fafe3879d4606dcbd1a9c9c3985e071a885d10133b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.2/claws-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6406dd4404146968f8afd352b42b65fbbe777fc963b7882044905d4f27dfa246"
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
