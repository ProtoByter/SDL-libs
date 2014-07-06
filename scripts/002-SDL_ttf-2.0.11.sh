#!/bin/sh -e
# SDL_ttf-2.0.11.sh by unknown (Updated by Spork Schivago)

SDL_TTF=SDL_ttf-2.0.11

## Download the source code.
if [ ! -f ${SDL_TTF}.tar.gz ]; then
  wget --continue http://www.libsdl.org/projects/SDL_ttf/release/${SDL_TTF}.tar.gz;
fi

## Unpack the source code.
rm -Rf ${SDL_TTF} && tar -xvzf ${SDL_TTF}.tar.gz && cd ${SDL_TTF}

## Patch the source code if a patch exists.
if [ -f ../../patches/${SDL_TTF}.patch ]; then
  echo "patching ${SDL_TTF}..."
  cat ../../patches/${SDL_TTF}.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
CPPFLAGS="-I${PSL1GHT}/ppu/include/SDL -I${PS3DEV}/portlibs/ppu/include/ -I${PS3DEV}/portlibs/ppu/include/freetype2" \
CFLAGS="-I${PSL1GHT}/ppu/include/SDL -I${PS3DEV}/portlibs/ppu/include/ -I${PS3DEV}/portlibs/ppu/include/freetype2" \
LDFLAGS="-L${PSL1GHT}/ppu/lib -L${PS3DEV}/portlibs/ppu/lib -lrt -llv2" \
PKG_CONFIG_PATH="${PS3DEV}/portlibs/ppu/lib/pkgconfig" \
../configure --prefix="${PS3DEV}/portlibs/ppu" --host=powerpc64-ps3-elf \
	--with-freetype-exec-prefix="${PS3DEV}/portlibs/ppu" \
	--with-sdl-exec-prefix="${PS3DEV}/portlibs/ppu" \
	--without-x \
	--disable-sdltest

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
