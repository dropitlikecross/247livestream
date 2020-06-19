
I'll document the steps needed to derive an FFmpeg build with the features you require (QuickSync) with support for extra codecs as may be needed, with extra notes on using the correct driver below:

**Ensure the platform is up to date:**

I noticed that you're on Ubuntu 18.04 LTS, so these instructions will do:

`sudo apt update && sudo apt -y upgrade && sudo apt -y dist-upgrade`

**Install baseline dependencies first:**

`sudo apt-get -y install autoconf automake build-essential libass-dev libtool pkg-config texinfo zlib1g-dev libva-dev cmake mercurial libdrm-dev libvorbis-dev libogg-dev git libx11-dev libperl-dev libpciaccess-dev libpciaccess0 xorg-dev intel-gpu-tools libwayland-dev xutils-dev libssl-dev`

Then add the Oibaf PPA, needed to install the latest development headers for libva:

```
sudo add-apt-repository ppa:oibaf/graphics-drivers
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade

```

**To address linker problems down the line with Ubuntu 18.04LTS:**

**Update:**  This is no longer needed, but it remains for future reference.

Referring to this:  [https://forum.openframeworks.cc/t/ubuntu-unable-to-compile-missing-glx-mesa/29367/2](https://forum.openframeworks.cc/t/ubuntu-unable-to-compile-missing-glx-mesa/29367/2)

Create the following symlink as shown:

```
sudo ln -s /usr/lib/x86_64-linux-gnu/libGLX_mesa.so.0 /usr/lib/x86_64-linux-gnu/libGLX_mesa.so

```

**Build the latest libva and all drivers from source:**

**Setup build environment:**

Work space init:

```
mkdir -p ~/vaapi
mkdir -p ~/ffmpeg_build
mkdir -p ~/ffmpeg_sources
mkdir -p ~/bin

```

Start with libva:

**1.  [Libva :](https://github.com/intel/libva)**

Libva is an implementation for VA-API (Video Acceleration API)

VA-API is an open-source library and API specification, which provides access to graphics hardware acceleration capabilities for video processing. It consists of a main library and driver-specific acceleration backends for each supported hardware vendor. It is a prerequisite for building the VAAPI driver components below.

```
cd ~/vaapi
git clone https://github.com/01org/libva
cd libva
./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
time make -j$(nproc) VERBOSE=1
sudo make -j$(nproc) install
sudo ldconfig -vvvv

```

**2.  [Gmmlib:](https://github.com/intel/gmmlib)**

The Intel(R) Graphics Memory Management Library provides device specific and buffer management for the Intel(R) Graphics Compute Runtime for OpenCL(TM) and the Intel(R) Media Driver for VAAPI.

The component is a prerequisite to the Intel Media driver build step below.

To build this, create a workspace directory within the vaapi sub directory and run the build:

```
mkdir -p ~/vaapi/workspace
cd ~/vaapi/workspace
git clone https://github.com/intel/gmmlib
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE= Release ../gmmlib
make -j$(nproc)

```

Then install the package:

```
sudo make -j$(nproc) install 

```

And proceed.

**3.  [Intel Media driver:](https://github.com/intel/media-driver)**

The Intel(R) Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware, released under the MIT license.

```
cd ~/vaapi/workspace
git clone https://github.com/intel/media-driver
cd media-driver
git submodule init
git pull
mkdir -p ~/vaapi/workspace/build_media
cd ~/vaapi/workspace/build_media

```

Configure the project with cmake:

```
cmake ../media-driver \
-DMEDIA_VERSION="2.0.0" \
-DBS_DIR_GMMLIB=$PWD/../gmmlib/Source/GmmLib/ \
-DBS_DIR_COMMON=$PWD/../gmmlib/Source/Common/ \
-DBS_DIR_INC=$PWD/../gmmlib/Source/inc/ \
-DBS_DIR_MEDIA=$PWD/../media-driver \
-DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu \
-DINSTALL_DRIVER_SYSCONF=OFF \
-DLIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri

```

Then build the media driver:

```
time make -j$(nproc) VERBOSE=1

```

Then install the project:

```
sudo make -j$(nproc) install VERBOSE=1

```

Add yourself to the video group:

```
sudo usermod -a -G video $USER

```

**Note:**  FFmpeg can now pick up the correct QSV driver on launch, typically  `iHD`  if its' installed and present in the  `ldconfig`  entries. You no longer have to set the correct driver system-wide in  `/etc/environment`  or per launch session in FFmpeg.

**4.  [libva-utils:](https://github.com/intel/libva-utils)**

This package provides a collection of tests for VA-API, such as  `vainfo`, needed to validate a platform's supported features (encode, decode & postproc attributes on a per-codec basis by VAAPI entry points information).

```
cd ~/vaapi
git clone https://github.com/intel/libva-utils
cd libva-utils
./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
time make -j$(nproc) VERBOSE=1
sudo make -j$(nproc) install

```

At this point, issue a reboot:

```
sudo systemctl reboot

```

This is needed to reflect the changes made above, such as adding your user to the video group.

Then on resume, proceed with the steps below.

**Build  [Intel's MSDK](https://github.com/Intel-Media-SDK/MediaSDK):**

This package provides an API to access hardware-accelerated video decode, encode and filtering on Intel® platforms with integrated graphics. It is supported on platforms that the intel-media-driver is targeted for.

For supported features per generation, see  [this](https://github.com/intel/media-driver/blob/master/README.md).

**Build steps:**

(a). Fetch the sources into the working directory  `~/vaapi`:

```
cd ~/vaapi
git clone https://github.com/Intel-Media-SDK/MediaSDK msdk
cd msdk
git submodule init
git pull

```

(b). Configure the build:

```
mkdir -p ~/vaapi/build_msdk
cd ~/vaapi/build_msdk
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_WAYLAND=ON -DENABLE_X11_DRI3=ON ../msdk
time make -j$(nproc) VERBOSE=1
sudo make install -j$(nproc) VERBOSE=1

```

CMake will automatically detect the platform you're on and enable the platform-specific hooks needed for a working build.

Create a library config file for the iMSDK:

```
sudo nano /etc/ld.so.conf.d/imsdk.conf

```

Content:

```
/opt/intel/mediasdk/lib
/opt/intel/mediasdk/plugins

```

Then run:

```
sudo ldconfig -vvvv

```

To proceed.

**Build a usable FFmpeg binary with the iMSDK:**

Include extra components as needed:

**(a). Build and deploy nasm:**  [Nasm](https://www.nasm.us/)  is an assembler for x86 optimizations used by x264 and FFmpeg. Highly recommended or your resulting build may be very slow.

Note that we've now switched away from Yasm to nasm, as this is the current assembler that x265,x264, among others, are adopting.

```
cd ~/ffmpeg_sources
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.gz
tar xzvf nasm-2.14.02.tar.gz
cd nasm-2.14.02
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean


```

**(b). Build and deploy libx264 statically:**  This library provides a H.264 video encoder. See the  [H.264 Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/H.264)  for more information and usage examples. This requires ffmpeg to be configured with  `--enable-gpl --enable-libx264`.

```
cd ~/ffmpeg_sources
git clone https://code.videolan.org/videolan/x264.git
cd ~/ffmpeg_sources/x264
git pull
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl --bit-depth=all --enable-pic
PATH="$HOME/bin:$PATH" make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean

```

**(c ). Build and configure libx265:**  This library provides a H.265/HEVC video encoder. See the  [H.265 Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/H.265)  for more information and usage examples.

```
cd ~/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd ~/ffmpeg_sources/x265/build/linux
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make -j$(nproc) VERBOSE=1
make -j$(nproc) install VERBOSE=1
make -j$(nproc) clean VERBOSE=1


```

**(d). Build and deploy the libfdk-aac library:**  This provides an AAC audio encoder. See the  [AAC Audio Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/AAC)  for more information and usage examples. This requires ffmpeg to be configured with  `--enable-libfdk-aac`  (and  `--enable-nonfree`  if you also included  `--enable-gpl`).

```
cd ~/ffmpeg_sources
git clone https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean

```

**(e). Build and configure libvpx:**

```
cd ~/ffmpeg_sources
git clone https://github.com/webmproject/libvpx
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --enable-runtime-cpu-detect --enable-vp9 --enable-vp8 \
--enable-postproc --enable-vp9-postproc --enable-multi-res-encoding --enable-webm-io --enable-better-hw-compatibility --enable-vp9-highbitdepth --enable-onthefly-bitpacking --enable-realtime-only --cpu=native --as=nasm 
time make -j$(nproc)
time make -j$(nproc) install
time make clean -j$(nproc)
time make distclean

```

**(f). Build LibVorbis:**

```
cd ~/ffmpeg_sources
wget -c -v http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.xz
tar -xvf libvorbis-1.3.6.tar.xz
cd libvorbis-1.3.6
./configure --enable-static --prefix="$HOME/ffmpeg_build"
time make -j$(nproc)
time make -j$(nproc) install
time make clean -j$(nproc)
time make distclean

```

**(g). Build FFmpeg:**

Build an FFmpeg binary with the required options:

```
cd ~/ffmpeg_sources
git clone https://github.com/FFmpeg/FFmpeg -b master
cd FFmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig:/opt/intel/mediasdk/lib/pkgconfig" ./configure \
  --pkg-config-flags="--static" \
  --prefix="$HOME/bin" \
  --bindir="$HOME/bin" \
  --extra-cflags="-I$HOME/bin/include" \
  --extra-ldflags="-L$HOME/bin/lib" \
  --extra-cflags="-I/opt/intel/mediasdk/include" \
  --extra-ldflags="-L/opt/intel/mediasdk/lib" \
  --extra-ldflags="-L/opt/intel/mediasdk/plugins" \
  --enable-libmfx \
  --enable-vaapi \
  --enable-opencl \
  --disable-debug \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libdrm \
  --enable-gpl \
  --cpu=native \
  --enable-libfdk-aac \
  --enable-libx264 \
  --enable-libx265 \
  --enable-openssl \
  --enable-pic \
  --extra-libs="-lpthread -lm -lz -ldl" \
  --enable-nonfree 
PATH="$HOME/bin:$PATH" make -j$(nproc) 
make -j$(nproc) install 
make -j$(nproc) distclean 
hash -r

```

Now you can launch your FFmpeg binary from  `~/bin/ffmpeg`, with the required features.

**Notes on encoding with the QSV encoders:**

Typically, you will need to initialize a hardware device that will be used by both the encoder(s) in use and filtering, as shown in the example below:

```
ffmpeg -y -loglevel debug -init_hw_device qsv=hw -filter_hw_device hw -hwaccel qsv -hwaccel_output_format qsv \
-i simpsons.mp4 -vf 'format=qsv,hwupload=extra_hw_frames=64'  \
-c:v hevc_qsv \
-bf 3 -b:v 3.75M -maxrate:v 3.75M -bufsize:v 0.5M -r:v 30 -c:a copy -f mp4 trolled.mp4
```

See how the hardware device for use with MFX sessions has been initialized (`-init_hw_device qsv=hw`) and mapped as available to filters such as  `hwupload`  (`-filter_hw_device hw`). Recommended for further reading: The  [Advanced Video Options](http://www.ffmpeg.org/ffmpeg.html#Advanced-Video-options)  section on FFmpeg wiki.

The example above demonstrates the use of the  `hevc_qsv`  encoders with some private options passed to it, for reference.

Another example, showing the use of the  `h264_qsv`  encoder:

```
ffmpeg -y -loglevel debug -init_hw_device qsv=hw -filter_hw_device hw -hwaccel qsv -hwaccel_output_format qsv \
-i simpsons.mp4 -vf 'format=qsv,hwupload=extra_hw_frames=64'  \
-c:v h264_qsv \
-bf 3 -b:v 15M -maxrate:v 15M -bufsize:v 2M -r:v 30 -c:a copy -f mp4 trolled.mp4

```

Take note that both examples above will use the constant bitrate control (CBR) method in MFX, as shown in the console log:

```
[hevc_qsv @ 0x55faf21eedc0] Using the constant bitrate (CBR) ratecontrol method
```

Rate control, similar to how the  [VAAPI implementation](http://www.ffmpeg.org/ffmpeg-codecs.html#VAAPI-encoders)  governs it, is driven by the parameters  `-b:v`  (target video bitrate) and the  `-maxrate:v`  (maximum video bitrate) passed to the encoder. If they are equal, CBR (constant bitrate control) is used. If maxrate is greater than target bitrate, then VBR, and in effect, look-ahead based control (if so desired) are enabled.

Observe how we call up the  `hwupload`  filter, chained with the  `format=qsv`  filter to ensure that the MFX runtime receives a supported pixel format. Failure to pass this video filter chain will result in initialization failure, with output similar to this:

```
[h264_qsv @ 0x560e1bda7280] Selected ratecontrol mode is unsupported
[h264_qsv @ 0x560e1bda7280] Low power mode is unsupported
[h264_qsv @ 0x560e1bda7280] Current frame rate is unsupported
[h264_qsv @ 0x560e1bda7280] Current picture structure is unsupported
[h264_qsv @ 0x560e1bda7280] Current resolution is unsupported
[h264_qsv @ 0x560e1bda7280] Current pixel format is unsupported
[h264_qsv @ 0x560e1bda7280] some encoding parameters are not supported by the QSV runtime. Please double check the input parameters.
Error initializing output stream 0:0 -- Error while opening encoder for output stream #0:0 - maybe incorrect parameters such as bit_rate, rate, width or height

```

The error message may seem ambiguous at first, but it stems primarily from mapping invalid options to the underlying MFX library, such as an unsupported pixel format.

The extra argument  `extra_hw_frames=64`  passed to  `hwupload`  has to do with the MFX runtime requiring a  [fixed frame pool size to be per-allocated](https://trac.ffmpeg.org/ticket/7120). Use a number suitable to your requirements. Generally, you'll need a larger number (64, or thereabouts) if using features such as  [look-ahead (LA-ICQ)](https://software.intel.com/en-us/articles/advanced-bitrate-control-methods-in-intel-media-sdk).
