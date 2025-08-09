class MpvMoonplayer < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "10a0f4654f62140a6dd4d380dcf0bbdbdcf6e697556863dc499c296182f081a3"
  head "https://github.com/mpv-player/mpv.git"
  
  keg_only "it is intended to only be used for building MoonPlayer. This formula is not recommended for daily use"

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on xcode: :build

  depends_on "ffmpeg-moonplayer"
  depends_on "libplacebo"
  depends_on "jpeg-turbo"
  depends_on "libass"
  depends_on "little-cms2"

  uses_from_macos "zlib"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # force meson find ninja from homebrew
    ENV["NINJA"] = which("ninja")

    args = %W[
      -Dhtml-build=disabled
      -Djavascript=enabled
      -Dlibmpv=true
      -Dcplayer=false
      -Dmanpage-build=disabled
      -Dmacos-touchbar=disabled
      -Dmacos-media-player=disabled
      -Dmacos-cocoa-cb=disabled
      --sysconfdir=#{pkgetc}
      --datadir=#{pkgshare}
    ]
    
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
  end
end
