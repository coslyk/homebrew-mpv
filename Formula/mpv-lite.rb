class MpvLite < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.32.0.tar.gz"
  sha256 "9163f64832226d22e24bbc4874ebd6ac02372cd717bef15c28a0aa858c5fe592"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    rebuild 1
    sha256 "c4d920659eb377953e6d9cfa780936712ca207faa4599836594cbfe46fbea13a" => :high_sierra
    sha256 "b049797237f360c09047e8b113a71b7bc2468dcb4c3d1fdba1110189a4f6ad3a" => :mojave
    sha256 "0b4928510cc766d4fcc21504173bef549c65b0ec6fb8a0977bb9e0de80bf9bb0" => :catalina
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
