#!/bin/sh
# SDL_NET-1.2.8.sh by unknown (Updated by Spork Schivago)

SDL_NET="SDL_net-1.2.8"

## Download the source code.
if [ ! -f ${SDL_NET}.tar.gz ]; then
  wget --continue http://www.libsdl.org/projects/SDL_net/release/${SDL_NET}.tar.gz
fi

## Unpack the source code.
rm -Rf ${SDL_NET} && tar -zxvf ${SDL_NET}.tar.gz && cd ${SDL_NET}

## Patch the source code if a patch exists.
if [ -f ../../patches/${SDL_NET}.patch ]; then
  echo "patching ${SDL_NET}..."
  cat ../../patches/${SDL_NET}.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
CPPFLAGS="-I${PSL1GHT}/ppu/include" \
CFLAGS="-I${PSL1GHT}/ppu/include" \
LDFLAGS="-L${PSL1GHT}/ppu/lib -lnet -lsysmodule" \
../configure --prefix="$PS3DEV/portlibs/ppu" --host=powerpc64-ps3-elf \
	--with-sdl-exec-prefix="$PS3DEV/portlibs/ppu" \
	--disable-sdltest \
	--disable-shared \
	--disable-gui

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
