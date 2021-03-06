class FontBhTtf < Formula
  desc "X.Org Fonts: font bh ttf"
  homepage "https://www.x.org/"
  ### http://www.linuxfromscratch.org/blfs/view/svn/x/x7font.html
  url "https://www.x.org/pub/individual/font/font-bh-ttf-1.0.3.tar.bz2"
  mirror "https://xorg.freedesktop.org/archive/individual/font/font-bh-ttf-1.0.3.tar.bz2"
  mirror "https://ftp.x.org/archive/individual/font/font-bh-ttf-1.0.3.tar.bz2"
  sha256 "1b4bea63271b4db0726b5b52c97994c3313b6023510349226908090501abd25f"
  revision 1
  # tag "linuxbrew"

  bottle do
    sha256 "0a24a4cfb38a8c3350a99c4da06e4e42267dd8770e50c628408acb8e60ee70e0" => :x86_64_linux
  end

  keg_only "part of Xorg-fonts package"

  depends_on "fontconfig" => :build
  depends_on "linuxbrew/xorg/bdftopcf" => :build
  depends_on "linuxbrew/xorg/font-util" => :build
  depends_on "linuxbrew/xorg/mkfontscale" => :build
  depends_on "pkg-config" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --with-fontrootdir=#{share}/fonts/X11
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
