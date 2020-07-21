class PassExtensionFormula < Formula

  @@enable_extensions = "PASSWORD_STORE_ENABLE_EXTENSIONS=true"
  @@extensions_dir = "PASSWORD_STORE_EXTENSIONS_DIR=#{HOMEBREW_PREFIX}/lib/password-store/extensions"

  @@gpg_cmd = Formula["gnupg"].opt_bin/"gpg"
  @@pass_cmd = Formula["pass"].opt_bin/"pass"

  @@example_password = "foo/bar"

  def caveats; <<~EOS
    To enable pass to find the installed extension #{name} you have to set the two environment variables

      #{@@enable_extensions}
      #{@@extensions_dir}

    once in your ~/.bash_profile or as prefixes for every call of the extension.
  EOS
  end

  def write_gpg_config
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
  end

  def init_passwordstore
    system %(#{@@gpg_cmd} --batch --gen-key batch.gpg)
    system %(#{@@pass_cmd} init testing)
    system %(#{@@pass_cmd} generate #{@@example_password} 15)
  end

  def define_command(name)
    %(#{@@enable_extensions} #{@@extensions_dir} #{@@pass_cmd} #{name})
  end

  def kill_gpg_agent
    system %(#{@@gpg_cmd}conf --kill gpg-agent)
  end

  def execute_test
    write_gpg_config

    begin
      init_passwordstore
      yield
    ensure
      kill_gpg_agent
    end
  end
end
