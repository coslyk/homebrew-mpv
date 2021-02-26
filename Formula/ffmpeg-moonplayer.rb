class FfmpegMoonplayer < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  license "GPL-2.0"
  head "https://github.com/FFmpeg/FFmpeg.git"

  stable do
    url "https://ffmpeg.org/releases/ffmpeg-4.3.2.tar.xz"
    sha256 "46e4e64f1dd0233cbc0934b9f1c0da676008cad34725113fb7f802cfa84ccddb"
  end

  bottle do
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    sha256 mojave: "b4ca9637076c853164246e556ab2cc439fe1f22c7dc2f5a1fca2b3193172cd68"
    sha256 catalina: "48b2fe49b58a8c47dc44f6b9796ef1f3bd8e6b97e1fe05d13cabc028d05ed8e6"
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
