class PassReport < Formula
  desc "Pass extension that reports age and length of passwords"
  homepage "https://github.com/Kdecherf/pass-report"
  url "https://github.com/Kdecherf/pass-report/archive/0.4.tar.gz"
  sha256 "afa2ef4e336af39dc9ec9705a4acd06d014c47b8194433ae4b5456f493423029"
  head "https://github.com/Kdecherf/pass-report.git"

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
      report = %(#{@@enable_extensions} #{@@extensions_dir} #{pass} report)
      system %(#{gpg} --batch --gen-key batch.gpg)
      system %(#{pass} init testing)
      system %(#{pass} generate foo/bar 15)
      system %(#{report} foo/bar > report.txt)
      assert_predicate File.read("output.txt"), :empty?
    ensure
      system %(#{gpg}conf --kill gpg-agent)
    end
  end
end
