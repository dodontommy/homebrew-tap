class ClawsTui < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/claws-tui"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.1/claws-tui-aarch64-apple-darwin.tar.xz"
      sha256 "552d264e935b020559d9c32c5b70c90d652eaa1d6d367ec9395a62d665ddb09f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.1/claws-tui-x86_64-apple-darwin.tar.xz"
      sha256 "e454ace3971db6bdad8f147cda0c6160f28768fccb055ef22e16c7d748ed8c9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.1/claws-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c1ab1bd94bb7da7a0bff6b4a491fe44e60e34bb747a964031bcd1be6358d0a08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws-tui/releases/download/v0.4.1/claws-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b345e0e5a5c97c3bceaab20969a559f7cdd8c7a050fb8d3d7e06b9321501c21d"
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
