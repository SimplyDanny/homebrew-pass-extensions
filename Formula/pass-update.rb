require File.expand_path("../Homebrew/PassExtensionFormula", __dir__)

class PassUpdate < PassExtensionFormula
  desc "Pass extension that provides an easy flow for updating passwords"
  homepage "https://github.com/roddhjav/pass-update"
  url "https://github.com/roddhjav/pass-update/archive/v2.1.tar.gz"
  sha256 "2b0022102238e022e7ee945b7622f4c270810cda46508084fcb193582aafaf6f"
  head "https://github.com/roddhjav/pass-update.git"

  depends_on "pass"

  def install
    system "make", "PREFIX=#{prefix}", "BASHCOMPDIR=#{bash_completion}", "install"
  end

  test do
    update_cmd = define_command "update"
    execute_test do
      system %(echo yes | #{update_cmd} foo/bar)
    end
  end
end
