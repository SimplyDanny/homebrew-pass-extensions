class PassUpdate < Formula
  desc "Pass extension that provides an easy flow for updating passwords"
  homepage "https://github.com/roddhjav/pass-update"
  url "https://github.com/roddhjav/pass-update/archive/v2.0.tar.gz"
  sha256 "3c994d0776fc8958120e604005423b7969db5dc4e30ebf90cd397b7a3b4706f1"
  head "https://github.com/roddhjav/pass-update.git"

  depends_on "pass"

  def install
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

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@#{name}
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    begin
      gpg = Formula["gnupg"].opt_bin/"gpg"
      pass = Formula["pass"].opt_bin/"pass"
      update = %(#{@@enable_extensions} #{@@extensions_dir} #{pass} update)
      system %(#{gpg} --batch --gen-key batch.gpg)
      system %(#{pass} init testing)
      system %(#{pass} generate foo/bar 15)
      system %(echo yes | #{update} foo/bar)
    ensure
      system %(#{gpg}conf --kill gpg-agent)
    end
  end
end
