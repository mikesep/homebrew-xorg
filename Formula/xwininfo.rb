class Xwininfo < Formula
  desc "X.Org Applications: xwininfo"
  homepage "https://www.x.org/"
  ### http://www.linuxfromscratch.org/blfs/view/svn/x/x7app.html
  url "https://www.x.org/pub/individual/app/xwininfo-1.1.5.tar.bz2"
  sha256 "7a405441dfc476666c744f5fcd1bc8a75abf8b5b1d85db7b88b370982365080e"
  bottle do
    cellar :any_skip_relocation
    sha256 "49bf62cd79c866f4083306f338373fb0a616014c2a8dd6ab7a589359d6c4d829" => :x86_64_linux
  end

  # tag "linuxbrew"

  depends_on "pkg-config" => :build
  depends_on "linuxbrew/xorg/libx11"
  depends_on "linuxbrew/xorg/xcb-util-wm"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --with-xcb-icccm
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
