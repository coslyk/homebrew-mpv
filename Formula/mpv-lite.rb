class MpvLite < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.32.0.tar.gz"
  sha256 "9163f64832226d22e24bbc4874ebd6ac02372cd717bef15c28a0aa858c5fe592"
  head "https://github.com/mpv-player/mpv.git"
  
  bottle do
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/bottles"
    sha256 "3aff5b9b82c82562eae31a47ef72c87d374a8098bd1a405b541319cca57a7029" => :high_sierra
  end

  depends_on "pkg-config" => :build

  depends_on "ffmpeg-lite"
  depends_on "jpeg"
  depends_on "libass"
  depends_on "little-cms2"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"
    
    args = %W[
      --prefix=#{prefix}
      --enable-libmpv-shared
      --disable-swift
      --disable-debug-build
      --disable-macos-media-player
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
    ]
    
    system "./bootstrap.py"
    system "python", "waf", "configure", *args
    system "python", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
