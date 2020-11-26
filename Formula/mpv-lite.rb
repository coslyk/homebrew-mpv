class MpvLite < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.33.0.tar.gz"
  sha256 "f1b9baf5dc2eeaf376597c28a6281facf6ed98ff3d567e3955c95bf2459520b4"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    sha256 "e27c1e010f4f246d26038b227f5b4d6ecf1eb98734cc4f5ab8296e060202e279" => :mojave
    sha256 "dbdb1d0f188cc579110d04e7882ef11fadd8550ab18c320fb7e695594eaba304" => :catalina
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

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
    
    system Formula["python@3.9"].opt_bin/"python3", "bootstrap.py"
    system Formula["python@3.9"].opt_bin/"python3", "waf", "configure", *args
    system Formula["python@3.9"].opt_bin/"python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
