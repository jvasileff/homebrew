require 'formula'

class Handbrake < Formula
  url 'http://downloads.sourceforge.net/project/handbrake/0.9.8/HandBrake-0.9.8.tar.bz2'
  homepage 'http://handbrake.fr'
  version '0.9.8'
  md5 '71637bab2719a976d62d5c1944227b59'

  depends_on 'wget'
  depends_on 'yasm'

  def install
    # fails without specifying llvm (10.7.3 Xcode 4.3 2012/02/26)
    ENV.llvm if ENV.compiler == :clang

    # Determine the arch
    arch = MacOS.prefer_64_bit? ? 'x86_64' : 'i386'

    args = ["--arch=#{arch}",
           "--force",
           "--debug=none"]

    system "./configure", *args

    system "cd build; make"

    prefix.install "build/xroot/HandBrake.app"
    bin.install "build/xroot/HandBrakeCLI"
  end

  def caveats; <<-EOS.undent
    HandBrake.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
      brew linkapps
    or:
      ln -s #{prefix}/HandBrake.app ~/Applications

    On Xcode 4.3, requires:
        brew install https://raw.github.com/adamv/homebrew-alt/master/duplicates/autoconf.rb
        brew link autoconf
        brew install https://raw.github.com/adammw/homebrew-alt/automake/duplicates/automake.rb
        brew link automake
        brew install https://raw.github.com/adammw/homebrew-alt/libtool/duplicates/libtool.rb
        brew link libtool
    EOS
  end
end
