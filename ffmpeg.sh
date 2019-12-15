#!/bin/bash
clear
echo "### Installation du FFMpeg pour CentOS 7"
echo "### Selon le site de FFMpeg; https://trac.ffmpeg.org/wiki/CompilationGuide/Centos"
echo " "
echo " "
echo "### ATTENTION : Vous devez est en utilisateur 'root' pour exécuter ce script."
read -p "### Appuyer sur [ENTRER] pour commencer... (ou CTRL+C pour annuler)"
echo "### Étape 1 : Pré-requis"
while true; do
	echo "### Étape 1.1 Repository Forge (repoforge.org) v0.5.3-1 X64"
    read -p "Installer ? (ignorer si déjà présent) [y/n]" ynrpm
    case $ynrpm in
        [YyOo]* ) 
			echo "### Étape 1.1 Installation du RPM pour RepoForge..."
			rpm -Uh --quiet http://pkgs.repoforge.org/rpmforge-release/rpmforge-#!/bin/bash
clear
echo "### Installation du FFMpeg pour CentOS 7"
echo "### Selon le site de FFMpeg; https://trac.ffmpeg.org/wiki/CompilationGuide/Centos"
echo " "
echo " "
echo "### ATTENTION : Vous devez est en utilisateur 'root' pour exécuter ce script."
read -p "### Appuyer sur [ENTRER] pour commencer... (ou CTRL+C pour annuler)"
echo "### Étape 1 : Pré-requis"
while true; do
	echo "### Étape 1.1 Repository Forge (repoforge.org) v0.5.3-1 X64"
    read -p "Installer ? (ignorer si déjà présent) [y/n]" ynrpm
    case $ynrpm in
        [YyOo]* ) 
			echo "### Étape 1.1 Installation du RPM pour RepoForge..."
			rpm -Uh --quiet http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
			break;;
        [Nn]* ) break;;
        * ) echo "### Entrer 'Y' ou 'O' pour 'oui' ou 'N' pour 'non'.";;
    esac
done

echo "### Étape 1.2 Nettoyage et mise à jour du système CentOS 7..."
rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,lame,x264,x265}
yum -q clean all
yum -y -q update
yum install -q -y autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel

echo "### Étape 2 : Compilation des librairies"
# NASM compiler, version la plus récente pour CentOS 7
yum -q -y remove nasm

rpm -i --quiet https://www.nasm.us/pub/nasm/stable/linux/nasm-2.14.02-0.fc27.x86_64.rpm
echo "### Étape 2 : Installation"
mkdir ~/ffmpeg_sources
#
#echo "### 2.1 Nasm 2.14"
#
#cd ~/ffmpeg_sources
#curl --quiet  -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
#tar xjf nasm-2.14.02.tar.bz2
#cd nasm-2.14.02
#./autogen.sh
#./configure --quiet --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
#make --quiet 
#make --quiet  install

echo "### Étape 2.2 Yasm 1.3"
cd ~/ffmpeg_sources
curl --quiet  -O -L https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --quiet --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make --quiet 
make --quiet  install

echo "### Étape 2.2 Codec x264 (latest)"
cd ~/ffmpeg_sources
git --quiet clone --depth 1 https://code.videolan.org/videolan/x264.git
cd x264
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --quiet --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make --quiet  
make --quiet  install

echo "### Étape 2.3 Codec x265 (latest)"
cd ~/ffmpeg_sources
hg -q clone https://bitbucket.org/multicoreware/x265
cd ~/ffmpeg_sources/x265/build/linux
cmake --no-warn-unused-cli -Wno-dev -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make --quiet 
make --quiet  install

echo "### Étape 2.4 Codec AAC (latest)"
cd ~/ffmpeg_sources
git --quiet clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --quiet --prefix="$HOME/ffmpeg_build" --disable-shared
make --quiet 
make --quiet  install

echo "### Étape 2.5 Codec Lame 3.100"
cd ~/ffmpeg_sources
curl --quiet  -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzf lame-3.100.tar.gz
cd lame-3.100
./configure --quiet --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make --quiet 
make --quiet  install

echo "### Étape 2.6 Codec Opus 1.3.1"
cd ~/ffmpeg_sources
curl --quiet  -O -L https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
tar xzf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --quiet --prefix="$HOME/ffmpeg_build" --disable-shared
make --quiet 
make --quiet  install

echo "### Étape 2.7 Codec VPX (latest)"
cd ~/ffmpeg_sources
git --quiet clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --quiet --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
make --quiet 
make --quiet  install

echo "### Étape 2.8 Codec Vorbis 1.3.5"
cd ~/ffmpeg_sources
wget -q http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
tar xzf libvorbis-1.3.5.tar.gz
cd libvorbis-1.3.5
./configure --quiet --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make --quiet 
make --quiet  install

echo "### Étape 2 complété : Librairies compilés, si aucune erreur c'est produite, vous pouvez continuer avec la compilation de FFMpeg."
read -p "### Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"

echo "### Étape 3 : Compilation de FFMpeg (latest), ceci peut être (très) long..."
cd ~/ffmpeg_sources
curl --quiet  -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --quiet
make --quiet 
make --quiet  install
hash -d ffmpeg

echo "### Installation terminé, faites 'ffmpeg -v' pour vérifier si il est correctement installé."release-0.5.3-1.el7.rf.x86_64.rpm
			break;;
        [Nn]* ) break;;
        * ) echo "### Entrer 'Y' ou 'O' pour 'oui' ou 'N' pour 'non'.";;
    esac
done

echo "### Étape 1.2 Nettoyage et mise à jour du système CentOS 7..."
rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,lame,x264,x265}
yum -q clean all
yum -y -q update
yum install -q -y autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel

echo "### Étape 2 : Compilation des librairies"
# NASM compiler, version la plus récente pour CentOS 7
yum -q -y remove nasm
rpm -i --quiet https://www.nasm.us/pub/nasm/stable/linux/nasm-2.14.02-0.fc27.x86_64.rpm
echo "### Étape 2 : Installation"
mkdir ~/ffmpeg_sources

echo "### 2.1 Nasm 2.14"
cd ~/ffmpeg_sources
curl --quiet  -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
tar xjf nasm-2.14.02.tar.bz2
cd nasm-2.14.02
./autogen.sh
./configure --quiet --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make --quiet 
make --quiet  install

echo "### Étape 2.2 Yasm 1.3"
cd ~/ffmpeg_sources
curl --quiet  -O -L https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --quiet --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make --quiet 
make --quiet  install

echo "### Étape 2.2 Codec x264 (latest)"
cd ~/ffmpeg_sources
git --quiet clone --depth 1 https://code.videolan.org/videolan/x264.git
cd x264
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --quiet --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make --quiet  
make --quiet  install

echo "### Étape 2.3 Codec x265 (latest)"
cd ~/ffmpeg_sources
hg -q clone https://bitbucket.org/multicoreware/x265
cd ~/ffmpeg_sources/x265/build/linux
cmake --no-warn-unused-cli -Wno-dev -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make --quiet 
make --quiet  install

echo "### Étape 2.4 Codec AAC (latest)"
cd ~/ffmpeg_sources
git --quiet clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --quiet --prefix="$HOME/ffmpeg_build" --disable-shared
make --quiet 
make --quiet  install

echo "### Étape 2.5 Codec Lame 3.100"
cd ~/ffmpeg_sources
curl --quiet  -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzf lame-3.100.tar.gz
cd lame-3.100
./configure --quiet --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make --quiet 
make --quiet  install

echo "### Étape 2.6 Codec Opus 1.3.1"
cd ~/ffmpeg_sources
curl --quiet  -O -L https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
tar xzf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --quiet --prefix="$HOME/ffmpeg_build" --disable-shared
make --quiet 
make --quiet  install

echo "### Étape 2.7 Codec VPX (latest)"
cd ~/ffmpeg_sources
git --quiet clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --quiet --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
make --quiet 
make --quiet  install

echo "### Étape 2.8 Codec Vorbis 1.3.5"
cd ~/ffmpeg_sources
wget -q http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
tar xzf libvorbis-1.3.5.tar.gz
cd libvorbis-1.3.5
./configure --quiet --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make --quiet 
make --quiet  install

echo "### Étape 2 complété : Librairies compilés, si aucune erreur c'est produite, vous pouvez continuer avec la compilation de FFMpeg."
read -p "### Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"

echo "### Étape 3 : Compilation de FFMpeg (latest), ceci peut être (très) long..."
cd ~/ffmpeg_sources
curl --quiet  -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --quiet
make --quiet 
make --quiet  install
hash -d ffmpeg

echo "### Installation terminé, faites 'ffmpeg -v' pour vérifier si il est correctement installé."
