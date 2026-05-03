class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/claws"
  version "0.2.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.2.10/claws-aarch64-apple-darwin.tar.xz"
      sha256 "7c1156f72bcbae9a03b5b6c4b85b64b77f0a01118b99fb992d87158abb57bf12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.2.10/claws-x86_64-apple-darwin.tar.xz"
      sha256 "869513438570ceda0ee1ac3b8b2f8a74cb88fb2da7094bcc86efb323e9e3b109"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.2.10/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d0b228ec5ed20485218afc3811b112666ef7e468b5b470b0f35671726b026933"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.2.10/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f276935a7013fe56612a5705e63ea3dccd5ba878f503d449f7b082b691385ec"
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
