class FfmpegMoonplayer < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  license "GPL-2.0"
  head "https://github.com/FFmpeg/FFmpeg.git"

  stable do
    url "https://ffmpeg.org/releases/ffmpeg-5.1.2.tar.xz"
    sha256 "619e706d662c8420859832ddc259cd4d4096a48a2ce1eefd052db9e440eef3dc"
  end

  bottle do
    rebuild 1
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    sha256 catalina: "6fe47cf84c3f65598e4b6a38ee6f7fda6b8cb1c1510c983bcc79c39d97ee7dc2"
    sha256 monterey: "88ac5ac85221b523ec9959701b666e0551eddb33b78a190bdcfcfaac381c1a6a"
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
      --disable-encoders
      --disable-frei0r
      --disable-libbluray
      --disable-libjack
      --disable-librtmp
      --disable-indev=jack
      --enable-encoder=png
    ]

    args << "--enable-neon" if Hardware::CPU.arm?

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
