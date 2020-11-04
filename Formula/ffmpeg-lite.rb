class FfmpegLite < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.3.1.tar.xz"
  sha256 "ad009240d46e307b4e03a213a0f49c11b650e445b1f8be0dda2a9212b34d2ffb"
  license "GPL-2.0"
  head "https://github.com/FFmpeg/FFmpeg.git"

  bottle do
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    rebuild 1
    sha256 "58b553ffd7a1c3ec4cc2051edbd0fa9d99432cf6230549b18f9a8bed2dddc841" => :high_sierra
    sha256 "01afc3b5cad0e7934c5f404742cfd1b57c058c95673db7e8ea68ec516f190989" => :mojave
    sha256 "91ae5779ce0863dc4639820d09d2de37f018c83b1835cb0b1419d0b2eac5cfd2" => :catalina
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gnutls"
  depends_on "libass"
  depends_on "libsoxr"
  depends_on "snappy"
  depends_on "speex"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-shared
      --enable-gpl
      --enable-version3
      --enable-avresample
      --enable-gnutls
      --enable-hardcoded-tables
      --enable-libass
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libsnappy
      --enable-libsoxr
      --enable-libspeex
      --enable-libxml2
      --enable-pthreads
      --enable-videotoolbox
      --disable-frei0r
      --disable-libbluray
      --disable-libjack
      --disable-librtmp
      --disable-indev=jack
    ]

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }
    
    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
