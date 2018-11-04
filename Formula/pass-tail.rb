class PassTail < Formula
  desc "Pass extension to avoid printing the password to the console"
  homepage "https://github.com/palortoff/pass-extension-tail"
  url "https://github.com/palortoff/pass-extension-tail/archive/v1.2.0.tar.gz"
  sha256 "3cb6492347e406b773a5feb63ae7c996272a12dfa74dec7a678fa63e94d68b9d"
  head "https://github.com/palortoff/pass-extension-tail.git"

  depends_on "pass"

  def install
    system %(make PREFIX=#{prefix} BASHCOMPDIR=#{bash_completion} install)
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
      tail = %(#{@@enable_extensions} #{@@extensions_dir} #{pass} tail)
      system %(#{gpg} --batch --gen-key batch.gpg)
      system %(#{pass} init testing)
      system %(#{pass} generate foo/bar 15)
      system %(#{tail} foo/bar > output.txt)
      assert_predicate File.read("output.txt"), :empty?
    ensure
      system %(#{gpg}conf --kill gpg-agent)
    end
  end
end
