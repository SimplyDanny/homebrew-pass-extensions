require File.expand_path("../Homebrew/PassExtensionFormula", __dir__)

class PassCsv < PassExtensionFormula
  desc "A pass extension to generate a CSV summary from key-value pairs"
  homepage "https://github.com/lahr/pass-csv"
  url "https://github.com/lahr/pass-csv/archive/v1.2.tar.gz"
  sha256 "681d8e0f7d27b73f2a9886fadd232e6282cfef3a01e7ce238ac79d6e9d6ce412"
  head "https://github.com/lahr/pass-csv.git"

  depends_on "pass"

  def install
    system %(make PREFIX=#{prefix} BASHCOMPDIR=#{bash_completion} install)
  end

  test do
    csv_cmd = define_command "csv"
    execute_test do
      system %(#{csv_cmd} key1 > output.txt)
      assert_equal %("name","key1"\n"#{@@example_password}","-"\n), File.read("output.txt")
    end
  end
end
