require 'formula'

class Handbrake < Formula
  head 'https://github.com/HandBrake/HandBrake/tarball/master'
  homepage 'http://handbrake.fr'
  #md5 'fbc81d892da7593ed363e67da9bac274'

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
      ln -s #{prefix}/HandBrake.app /Applications

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
