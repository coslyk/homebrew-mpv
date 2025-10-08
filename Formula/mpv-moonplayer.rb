class MpvMoonplayer < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  sha256 "10a0f4654f62140a6dd4d380dcf0bbdbdcf6e697556863dc499c296182f081a3"
  head "https://github.com/mpv-player/mpv.git"

  stable do
    url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.40.0.tar.gz"
    sha256 "10a0f4654f62140a6dd4d380dcf0bbdbdcf6e697556863dc499c296182f081a3"

    # Backport support for FFmpeg 8
    patch do
      url "https://github.com/mpv-player/mpv/commit/26b29fba02a2782f68e2906f837d21201fc6f1b9.patch?full_index=1"
      sha256 "ac7e5d8e765186af2da3bef215ec364bd387d43846ee776bd05f01f9b9e679b2"
    end
  end

  bottle do
    rebuild 1
    root_url "https://github.com/coslyk/homebrew-mpv/releases/download/continuous"
    sha256 cellar: :any, sequoia: "f7585d8b646669ef2b6c618150464bdbdbbb13b23cf8bbcb30e0d42eec0430b8"
    sha256 arm64_sonoma: "6b846dee1692d15db726182a8e5d42bd8867d9debd935c9ad4e8720360826f78"
  end
  
  keg_only "it is intended to only be used for building MoonPlayer. This formula is not recommended for daily use"

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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
      -Djavascript=disabled
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
