require File.expand_path("../Homebrew/PassExtensionFormula", __dir__)

class PassReport < PassExtensionFormula
  desc "Pass extension that reports age and length of passwords"
  homepage "https://github.com/Kdecherf/pass-report"
  url "https://github.com/Kdecherf/pass-report/archive/0.4.tar.gz"
  sha256 "afa2ef4e336af39dc9ec9705a4acd06d014c47b8194433ae4b5456f493423029"
  head "https://github.com/Kdecherf/pass-report.git"

  depends_on "pass"

  def install
    system %(make PREFIX=#{prefix} install)
  end

  test do
    report_cmd = define_command "report"
    execute_test do
      system %(#{report_cmd} #{@@example_password} > report.txt)
      assert_predicate File.read("report.txt"), :empty?
    end
  end
end
