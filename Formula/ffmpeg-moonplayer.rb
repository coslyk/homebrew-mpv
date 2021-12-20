class FfmpegMoonplayer < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  license "GPL-2.0"
  head "https://github.com/FFmpeg/FFmpeg.git"

  stable do
    url "https://ffmpeg.org/releases/ffmpeg-4.4.1.tar.xz"
    sha256 "eadbad9e9ab30b25f5520fbfde99fae4a92a1ae3c0257a8d68569a4651e30e02"
  end

  bottle do
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    rebuild 1
    sha256 catalina: "339bc345699baa22583b17e237da9fea2f1579846e8bc2a61e17a8158e827030"
  end

  keg_only "it is intended to only be used for building MoonPlayer. This formula is not recommended for daily use"

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

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
      --disable-encoders
      --disable-frei0r
      --disable-libbluray
      --disable-libjack
      --disable-librtmp
      --disable-indev=jack
      --enable-encoder=png
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
