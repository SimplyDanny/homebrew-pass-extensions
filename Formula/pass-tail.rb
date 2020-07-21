require File.expand_path("../Homebrew/PassExtensionFormula", __dir__)

class PassTail < PassExtensionFormula
  desc "Pass extension to avoid printing the password to the console"
  homepage "https://github.com/palortoff/pass-extension-tail"
  url "https://github.com/palortoff/pass-extension-tail/archive/v1.2.0.tar.gz"
  sha256 "3cb6492347e406b773a5feb63ae7c996272a12dfa74dec7a678fa63e94d68b9d"
  head "https://github.com/palortoff/pass-extension-tail.git"

  depends_on "pass"

  def install
    system %(make PREFIX=#{prefix} BASHCOMPDIR=#{bash_completion} install)
  end

  test do
    tail_cmd = define_command "tail"
    execute_test do
      system %(#{tail_cmd} #{@@example_password} > output.txt)
      assert_predicate File.read("output.txt"), :empty?
    end
  end
end
