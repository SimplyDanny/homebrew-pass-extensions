class PassClip < Formula
  desc "Pass extension that lets you quickly copy to clipboard passwords using fzf or rofi"
  homepage "https://github.com/ibizaman/pass-clip"
  url "https://github.com/ibizaman/pass-clip/archive/v0.2.tar.gz"
  sha256 "f3646954057dfe7fefd998eb95e3d9d2f56119bcd366f8ecb768c0ff76b264d6"
  head "https://github.com/ibizaman/pass-clip.git"

  depends_on "pass"
  depends_on "fzf"

  def install
    inreplace "Makefile", "-Dm0755", "-m0755" # BSD's `install` has no `-D` option.
    system %(make PREFIX=#{prefix} install)
  end

  @@enable_extensions = "PASSWORD_STORE_ENABLE_EXTENSIONS=true"
  @@extensions_dir = "PASSWORD_STORE_EXTENSIONS_DIR=#{HOMEBREW_PREFIX}/lib/password-store/extensions"

  def caveats; <<~EOS
    To enable pass to find the installed extension #{name} you have to set the two environment variables

      #{@@enable_extensions}
      #{@@extensions_dir}

    once in your ~/.bash_profile or as prefixes for every call of the extension.
  EOS
  end
end
