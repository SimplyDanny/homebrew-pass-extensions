require File.expand_path("../Homebrew/PassExtensionFormula", __dir__)

class PassClip < PassExtensionFormula
  desc "Pass extension that lets you quickly copy to clipboard passwords using fzf or rofi"
  homepage "https://github.com/ibizaman/pass-clip"
  url "https://github.com/ibizaman/pass-clip/archive/v0.3.tar.gz"
  sha256 "da07f6ad92901f960e6afe6324fc2fc86b4ce23f20cbe041ec19a1c7b1490009"
  head "https://github.com/ibizaman/pass-clip.git"

  depends_on "pass"
  depends_on "fzf"

  def install
    inreplace "Makefile", "-Dm0755", "-m0755" # BSD's `install` has no `-D` option.
    system %(make PREFIX=#{prefix} install)
  end

  test do
    # Automatic test not possible. Interactive password selection is necessary.
  end
end
