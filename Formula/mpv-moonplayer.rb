class MpvMoonplayer < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.33.1.tar.gz"
  sha256 "100a116b9f23bdcda3a596e9f26be3a69f166a4f1d00910d1789b6571c46f3a9"
  head "https://github.com/mpv-player/mpv.git"

  keg_only "it is intended to only be used for building MoonPlayer. This formula is not recommended for daily use"

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  depends_on "ffmpeg-moonplayer"
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
    
    system Formula["python@3.9"].opt_bin/"python3", "bootstrap.py"
    system Formula["python@3.9"].opt_bin/"python3", "waf", "configure", *args
    system Formula["python@3.9"].opt_bin/"python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
