class Libx11 < Formula
  desc "X.Org Libraries: libX11"
  homepage "https://www.x.org/" ### http://www.linuxfromscratch.org/blfs/view/svn/x/x7lib.html
  url "https://ftp.x.org/pub/individual/lib/libX11-1.6.9.tar.bz2"
  sha256 "9cc7e8d000d6193fa5af580d50d689380b8287052270f5bb26a5fb6b58b2bed1"
  # tag "linuxbrew"

  bottle do
    sha256 "761a6d9d3974cab7b5aedeaec8bc4c037318f6eed8aee00bcb8e01dde15d9a59" => :x86_64_linux
  end

  option "without-test", "Skip compile-time tests"
  option "with-specs", "Build specifications"

  depends_on "linuxbrew/xorg/util-macros" => :build
  depends_on "linuxbrew/xorg/xtrans" => :build
  depends_on "pkg-config" => :build
  depends_on "linuxbrew/xorg/libxcb"
  depends_on "linuxbrew/xorg/xorgproto"

  if build.with? "specs"
    depends_on "xmlto" => :build
    depends_on "lynx" => :build
    depends_on "libxslt" => :build
    depends_on "linuxbrew/xorg/xorg-sgml-doctools" => :build
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
      --enable-loadable-i18n
      --enable-xthreads
      --enable-specs=#{build.with?("specs") ? "yes" : "no"}
    ]

    # ensure we can find the docbook XML tags
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog" if build.with? "specs"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <X11/Xlib.h>
      #include <stdio.h>
      int main() {
        Display* disp = XOpenDisplay(NULL);
        if (disp == NULL)
        {
          fprintf(stderr, "Unable to connect to display\\n");
          return 7;
        }

        int screen_num = DefaultScreen(disp);
        unsigned long background = BlackPixel(disp, screen_num);
        unsigned long border = WhitePixel(disp, screen_num);
        int width = 60, height = 40;
        Window win = XCreateSimpleWindow(disp, DefaultRootWindow(disp), 0, 0, width, height, 2, border, background);
        XSelectInput(disp, win, ButtonPressMask|StructureNotifyMask);
        XMapWindow(disp, win); // display blank window

        XGCValues values;
        values.foreground = WhitePixel(disp, screen_num);
        values.line_width = 1;
        values.line_style = LineSolid;
        GC pen = XCreateGC(disp, win, GCForeground|GCLineWidth|GCLineStyle, &values);
        // draw two diagonal lines
        XDrawLine(disp, win, pen, 0, 0, width, height);
        XDrawLine(disp, win, pen, width, 0, 0, height);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-lX11"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
