class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "8e5253e5968f364f86d2f1cfb24c95a68890bf620886c644c7df981b803bb808"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7222ad5da0cc693ff86101262b1b73e72998f2838c7ce4e0f602c833623731bf"
    sha256 cellar: :any,                 arm64_ventura:  "5ec15b1b11435483d4d7a81a2e98ce1950c9553d86923c02a4964b8de294ce27"
    sha256 cellar: :any,                 arm64_monterey: "537fcd66c7b4037c20a7a3ef2733f491b45fb7fa06811c4bca0c7abf4d7ce7ab"
    sha256 cellar: :any,                 arm64_big_sur:  "6cdd65b054adf85300d597a22e6012a60cbcdf3c8665e20b866d052515b4894e"
    sha256 cellar: :any,                 sonoma:         "48de67fcf3ac289bf202c1385af9afe472a3a6f3c3034a6af66f3b2e4643a8fd"
    sha256 cellar: :any,                 ventura:        "5ae7a3541673b37d05c5787d199ada0a77b40328f1d454d3e472429b23159595"
    sha256 cellar: :any,                 monterey:       "f8336b6db3727aebbdf842e065afa37de43432440823be5c7c3b57e3748e2585"
    sha256 cellar: :any,                 big_sur:        "048861dbb45f7afb2742d11b6cbc5fc0675e1ff44c11fcf7000c07a6e595d2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e2b5ccfa0ec16df1acd12a522d4ad935a13ab19cdd530f35a769e77d22a019"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
