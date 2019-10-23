class MpvLite < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.29.1.tar.gz"
  sha256 "f9f9d461d1990f9728660b4ccb0e8cb5dce29ccaa6af567bec481b79291ca623"
  head "https://github.com/mpv-player/mpv.git"
  
  bottle do
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/bottles"
    sha256 "055c75d33d6d79baf58197120fa4cfb119b3c6edfcb91d091c4d282f81e7ffd2" => :high_sierra
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
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
    ]
    
    system "./bootstrap.py"
    system "python", "waf", "configure", *args
    system "python", "waf", "install"
    
    system "python", "TOOLS/osxbundle.py", "build/mpv"
    prefix.install "build/mpv.app"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
