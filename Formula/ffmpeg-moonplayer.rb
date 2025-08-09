class FfmpegMoonplayer < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  license "GPL-2.0"
  head "https://github.com/FFmpeg/FFmpeg.git"

  stable do
    url "https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.xz"
    sha256 "733984395e0dbbe5c046abda2dc49a5544e7e0e1e2366bba849222ae9e3a03b1"
  end

  keg_only "it is intended to only be used for building MoonPlayer. This formula is not recommended for daily use"

  depends_on "pkg-config" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gnutls"
  depends_on "libass"
  depends_on "libsoxr"
  depends_on "snappy"
  depends_on "speex"
  depends_on "xz"

  on_intel do
    depends_on "nasm" => :build
  end

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
      --enable-audiotoolbox
      --disable-encoders
      --disable-frei0r
      --disable-libbluray
      --disable-libjack
      --disable-librtmp
      --disable-indev=jack
      --enable-encoder=png
    ]

    args << "--enable-neon" if Hardware::CPU.arm?
    args << "--cc=#{ENV.cc}" if Hardware::CPU.intel?

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath/"tools").children.select { |f| f.file? && f.executable? }
    pkgshare.install buildpath/"tools/python"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
