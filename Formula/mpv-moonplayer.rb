class MpvMoonplayer < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.35.0.tar.gz"
  sha256 "dc411c899a64548250c142bf1fa1aa7528f1b4398a24c86b816093999049ec00"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    rebuild 1
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    sha256 catalina: "bb1dca44c1f14d40e8f8f96356943ab46d5d0885a7f2e5d4fb02cdf57dd009d9"
    sha256 monterey: "1b438e52568467087326511d49d1d8156d9f175b87fb07550bc40e9421a0972d"
  end
  
  keg_only "it is intended to only be used for building MoonPlayer. This formula is not recommended for daily use"

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

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
    
    system Formula["python@3.10"].opt_bin/"python3", "bootstrap.py"
    system Formula["python@3.10"].opt_bin/"python3", "waf", "configure", *args
    system Formula["python@3.10"].opt_bin/"python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
  end
end
