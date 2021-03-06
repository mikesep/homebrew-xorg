class Libxft < Formula
  desc "X.Org Libraries: libXft"
  homepage "https://www.x.org/" ### http://www.linuxfromscratch.org/blfs/view/svn/x/x7lib.html
  url "https://ftp.x.org/pub/individual/lib/libXft-2.3.3.tar.bz2"
  sha256 "225c68e616dd29dbb27809e45e9eadf18e4d74c50be43020ef20015274529216"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d6f440da2a9fc76383bdf7c8157ae6d253fca26773abc5bf341eb30ab3aa3ac" => :x86_64_linux
  end

  option "without-test", "Skip compile-time tests"
  deprecated_option "with-brewed-bzip2" => "with-bzip2"
  deprecated_option "with-brewed-zlib" => "with-zlib"

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "linuxbrew/xorg/libxrender"
  depends_on "bzip2" => :optional
  depends_on "zlib" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
