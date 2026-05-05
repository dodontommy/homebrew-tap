class Claws < Formula
  desc "TUI multiplexer for Claude Code sessions"
  homepage "https://github.com/dodontommy/claws-tui"
  version "0.3.6"

  # The package was renamed to `claws-tui` in v0.4.0 (the unsuffixed
  # `claws` slot collided with an unrelated AWS TUI). Old install
  # commands still work — GitHub redirects the rename, so the v0.3.6
  # tarball URLs below resolve correctly — but new releases are only
  # published under the `claws-tui` formula. This formula stays pinned
  # at 0.3.6 as a soft landing for legacy `brew install dodontommy/tap/claws`
  # invocations; switch to `claws-tui` to get current releases.
  deprecate! date: "2026-05-05", because: "renamed to `claws-tui`. Run `brew install dodontommy/tap/claws-tui` for v0.4.0 and beyond"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.6/claws-aarch64-apple-darwin.tar.xz"
      sha256 "18bad10e59db6e6e059dfdae534f63ef8d5ad9de771f74119d0b722809e91e66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.6/claws-x86_64-apple-darwin.tar.xz"
      sha256 "948bbc07113966679935634602f46507488b47c6457f52f362bc6f35e78a1bbb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.6/claws-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cff895d07dffcda608695b98dc2b73ddadf00ca8a6cb7eb01f2054e2da81f69a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dodontommy/claws/releases/download/v0.3.6/claws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5314a9437995ffbb561aab8e0e3cb03865e1d4b36ed3c16067b6fa96375cfb6e"
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
