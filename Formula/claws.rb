class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/claws"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.2.2/claws-aarch64-apple-darwin.tar.xz"
      sha256 "ed5c595eaf26282492a76f71dd3aeb4bc9244dd49c2c885f348bec08dbfc1635"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.2.2/claws-x86_64-apple-darwin.tar.xz"
      sha256 "d77a3d88f6d630206fee6128a800b140da89c1418d9ffd90c3c178c00635bb61"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.2.2/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "15a5cb5b9445d7dce3b7afa4ebb91f537ec095c66e06967ec627da6d8e1844ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.2.2/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d95b01d89ed3df7ca7b11b31b168b7d971bf9238ddc8cbaaa2310a5f05e67646"
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
