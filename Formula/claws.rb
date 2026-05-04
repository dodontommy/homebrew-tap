class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/claws"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.1/claws-aarch64-apple-darwin.tar.xz"
      sha256 "461242f870f127958703009f7342589a9a8abfbefd9ea01e2f2314b841e632bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.1/claws-x86_64-apple-darwin.tar.xz"
      sha256 "b918be9ac08a8c074ec1d01a5afb5d5120d671e78a977d4a4f06a1559e9858ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.1/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f739e3338b79ef162452cc3cbcd7510fa8591ebe3f2e2c1e381465658ba60c30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.1/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c811c2238be711cc0b7d54d7c35a7b24572f68999fba6fea65bd19400e34d66"
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
