class MpvLite < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.32.0.tar.gz"
  sha256 "9163f64832226d22e24bbc4874ebd6ac02372cd717bef15c28a0aa858c5fe592"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    sha256 "71bb056407ad489bdcde137fdfb089d3eb69c2e03f2c27c547b5b6064f21cda2" => :high_sierra
    sha256 "5239ec40a8f30692a07cb00f178208d41551aa5bdda63f513e1fe40974a76e82" => :mojave
    sha256 "481bf9f9de399c34bd596bee4bb9de9fff6ae4a4e2c6bbfba239e0d979755fe7" => :catalina
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
