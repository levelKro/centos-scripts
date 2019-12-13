#!/bin/bash
clear
echo "### Installation du FFMpeg pour CentOS 7"
echo " "
echo " "
read -p "### Appuyer sur [ENTRER] pour commencer... (ou CTRL+C pour annuler)"

while true; do
    read -p "Avez-vous besoin d'installer le Repository Forge ?" ynrpm
    case $ynrpm in
        [YyOo]* ) 
echo "### Installation du RPM RepoForge"
rpm -Uhv --quiet http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done

echo "### Actualisation du systeme"
yum -y -q update
yum -y -q remove libvpx libogg libvorbis libtheora libx264 x264 ffmpeg

echo "### Installation des pre-requis"
yum -y -q install glibc gcc gcc-c++ autoconf automake libtool git make nasm pkgconfig subversion
yum -y -q install SDL-devel a52dec a52dec-devel alsa-lib-devel faac faac-devel faad2 faad2-devel
yum -y -q install freetype-devel giflib gsm gsm-devel imlib2 imlib2-devel  libICE-devel libSM-devel libX11-devel
yum -y -q install libXau-devel libXdmcp-devel libXext-devel libXrandr-devel libXrender-devel libXt-devel
#yum -y -q install libogg libvorbis vorbis-tools lame lame-devel libtheora theora-tools
yum -y -q install mesa-libGL-devel mesa-libGLU-devel xorg-x11-proto-devel zlib-devel
yum -y -q install ncurses-devel
yum -y -q install libdc1394 libdc1394-devel
yum -y -q install amrnb-devel amrwb-devel opencore-amr-devel 
# NASM compiler, version la plus récente pour CentOS 7
rpm -iv https://www.nasm.us/pub/nasm/stable/linux/nasm-2.14.02-0.fc27.x86_64.rpm

while true; do
    read -p "Besoin de compiler codec Lame MP3 ?" ynmp3
    case $ynmp3 in
        [YyOo]* ) 
echo "### Librairie MP3 Lame"
cd /opt  
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz 
tar xzf lame-3.99.5.tar.gz
rm -f lame-3.99.5.tar.gz  
cd lame-3.99.5  
./configure
make -s  
make -s install  
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec XViD ?" ynxvid
    case $ynxvid in
        [YyOo]* ) 
echo "### Librairie XVID"
cd /opt
wget http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz
tar xzf xvidcore-1.3.2.tar.gz
rm -f xvidcore-1.3.2.tar.gz
cd xvidcore/build/generic
./configure --prefix="$HOME/ffmpeg_build"
make -s
make -s install	
make -s clean 
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec OGG ?" ynogg
    case $ynogg in
        [YyOo]* ) 
echo "### Librairie OGG"
cd /opt
wget http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar xzf libogg-1.3.1.tar.gz
rm -f libogg-1.3.1.tar.gz
cd libogg-1.3.1
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make -s
make -s install
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec Vorbis ?" ynvorbis
    case $ynvorbis in
        [YyOo]* ) 
echo "### Librairie Vorbis"
cd /opt
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzf libvorbis-1.3.4.tar.gz
rm -f libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make -s
make -s install
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec Theora ?" yntheora
    case $yntheora in
        [YyOo]* ) 
echo "### Librairie Theora"
cd /opt
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
tar xzf libtheora-1.1.1.tar.gz
rm -f libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-examples --disable-shared --disable-sdltest --disable-vorbistest
make -s
make -s install
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec AAC ?" ynaac
    case $ynaac in
        [YyOo]* ) 
echo "### Librairie AAC"
cd /opt
wget http://downloads.sourceforge.net/opencore-amr/vo-aacenc-0.1.2.tar.gz
tar xzf vo-aacenc-0.1.2.tar.gz
rm -f vo-aacenc-0.1.2.tar.gz
cd vo-aacenc-0.1.2
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make -s
make -s install
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec FAAC ?" ynfaac
    case $ynfaac in
        [YyOo]* ) 
echo "### Librairie FAAC"
cd /opt
wget http://downloads.sourceforge.net/faac/faac-1.28.tar.gz
tar -xzf faac-1.28.tar.gz
rm -f faac-1.28.tar.gz
cd faac-1.28
./bootstrap
./configure
make -s
make -s install
ldconfig
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec Yasm ?" ynyasm
    case $ynyasm in
        [YyOo]* ) 
echo "### Librairie YASM"
yum remove yasm
cd /opt
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzf yasm-1.2.0.tar.gz
rm -f yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make -s
make -s install
export "PATH=$PATH:$HOME/bin"
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)" 
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec VPx ?" ynvpx
    case $ynvpx in
        [YyOo]* ) 
echo "### Librairie VPx"
cd /opt
git clone https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
git checkout tags/v.1.3.0
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make -s
make -s install
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Besoin de compiler codec x264 ?" ynx264
    case $ynx264 in
        [YyOo]* ) 
echo "### Librairie x264"
cd /opt
git clone git://git.videolan.org/x264.git
cd x264
#WARNING: "--disable-asm" est du a une erreur, le nasm présent sous CentOS7 est 2.10 mais la version 3.10 est requise, doit installer idéalement un nasm plus récent sans yum
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-asm
make -s
make -s install
make -s clean
read -p "### Pas d'erreur ? Appuyer sur [ENTRER] pour continuer... (ou CTRL+C pour annuler)"
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done

export LD_LIBRARY_PATH=/usr/local/lib/
echo /usr/local/lib >> /etc/ld.so.conf.d/custom-libs.conf
ldconfig

echo "### Encodage du FFMpeg"
cd /opt
git clone git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
git checkout release/2.5
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" --extra-libs=-ldl --enable-version3 --enable-libvpx --enable-libfaac --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libvo-aacenc --enable-libxvid --disable-ffplay --enable-gpl --enable-postproc --enable-nonfree --enable-avfilter --enable-pthreads
make -s
make -s install
make -s clean
echo "### Installation complete"
