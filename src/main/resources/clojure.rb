class Clojure < Formula
  desc "The Clojure Programming Language"
  homepage "https://clojure.org"
  version "${project.version}"
  url "https://download.clojure.org/install/brew/clojure-scripts-${project.version}.tar.gz"
  sha256 "SHA"

  bottle :unneeded

  depends_on :java => "1.7+"
  depends_on "rlwrap"

  def install
    prefix.install Dir["*.jar"]
    prefix.install "deps.edn"
    inreplace "clojure", /PREFIX/, prefix
    bin.install "clojure"
    bin.install "clj"
  end

  def caveats; <<-EOS.undent
      Run `clojure -h` to see Clojure runner options.
      Run `clj` for an interactive Clojure REPL.
    EOS
  end

  test do
    ENV.java_cache
    system("#{bin}/clj -e nil")
    %w[clojure clj].each do |clj|
      assert_equal "2", shell_output("#{bin}/#{clj} -e \"(+ 1 1)\"").strip
    end
  end
end
