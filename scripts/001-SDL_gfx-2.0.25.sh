#!/bin/sh
# SDL_gfx-2.0.25 by unknown (Updated by Spork Schivago)

SDL_GFX=SDL_gfx-2.0.25

## Download the source code.
if [ ! -f ${SDL_GFX}.tar.gz ]; then
  wget --continue http://sourceforge.net/projects/sdlgfx/files/latest/download -O ${SDL_GFX}.tar.gz;
fi

## Unpack the source code.
rm -Rf ${SDL_GFX} && tar -zxvf ${SDL_GFX}.tar.gz && cd ${SDL_GFX}

## Patch the source code if a patch exists.
if [ -f ../../patches/${SDL_GFX}.patch ]; then
  echo "patching ${SDL_GFX}..."
  cat ../../patches/${SDL_GFX}.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
CFLAGS="-I${PSL1GHT}/ppu/include/SDL -I${PS3DEV}/portlibs/ppu/include/ -I${PS3DEV}/portlibs/ppu/include/freetype2" \
LDFLAGS="-L${PSL1GHT}/ppu/lib -L${PS3DEV}/portlibs/ppu/lib -lrt -llv2" \
PKG_CONFIG_PATH="${PS3DEV}/portlibs/ppu/lib/pkgconfig" \
../configure --prefix="${PS3DEV}/portlibs/ppu" --host=powerpc64-ps3-elf \
	--with-sdl-exec-prefix="${PS3DEV}/portlibs/ppu" \
	--disable-sdltest --disable-mmx --enable-option-checking

## Compile and install.
${MAKE:-make} -j4 $aclocal_kluge && ${MAKE:-make} $aclocal_kluge install
