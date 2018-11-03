class PassOtp < Formula
  desc "Pass extension for managing one-time-password (OTP) tokens"
  homepage "https://github.com/tadfisher/pass-otp"
  url "https://github.com/tadfisher/pass-otp/archive/v1.1.1.tar.gz"
  sha256 "edb3142ab81d70af4e6d1c7f13abebd7c349be474a3f9293d9648ee91b75b458"
  head "https://github.com/tadfisher/pass-otp.git"

  depends_on "oath-toolkit"
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

    (testpath/"secret.txt").write <<~EOS
      otpauth://totp/totp-secret?secret=AAAAAAAAAAAAAAAA&issuer=totp-secret
    EOS

    begin
      gpg = Formula["gnupg"].opt_bin/"gpg"
      pass = Formula["pass"].opt_bin/"pass"
      otp = %(#{@@enable_extensions} #{@@extensions_dir} #{pass} otp)
      system %(#{gpg} --batch --gen-key batch.gpg)
      system %(#{pass} init testing)
      system %(#{pass} generate foo/bar 15)
      system %(#{otp} insert foo/bar < secret.txt)
      system %(#{otp} foo/bar)
    ensure
      system %(#{gpg}conf --kill gpg-agent)
    end
  end
end
