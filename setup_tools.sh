#!/usr/bin/env bash
set -eu

# Variables
GCC_COMMAND=aarch64-elf-gcc
QEMU_COMMAND=qemu-system-aarch64
GCC_PACKAGE_FILE=gcc-linaro-7.2.1-2017.11-x86_64_aarch64-elf.tar.xz
GCC_DOWNLOAD_URL=https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/aarch64-elf/$GCC_PACKAGE_FILE

if [ ! -v TOOLDIR ]; then
  TOOLDIR=$HOME/MyTools
fi

GCC_INSTALL_DIR=$TOOLDIR/$GCC_COMMAND
GCC_COMMAND_PATH=$GCC_INSTALL_DIR/bin/$GCC_COMMAND

TMPDIR=/tmp

: "install $GCC_COMMAND" && {
  cd $TMPDIR

  if type $GCC_COMMAND_PATH > /dev/null 2>&1; then 
    echo "It seems $GCC_COMMAND exists in $GCC_COMMAND_PATH. skip install."
  else
    wget $GCC_DOWNLOAD_URL -O $GCC_PACKAGE_FILE
    wget $GCC_DOWNLOAD_URL.asc -O $GCC_PACKAGE_FILE.asc
    : "MD5 hash check" && {
      if md5sum -c $GCC_PACKAGE_FILE.asc;then
        mkdir -p $GCC_INSTALL_DIR
        tar xvf $GCC_PACKAGE_FILE -C $GCC_INSTALL_DIR --strip-components 1
        echo export PATH=\"$GCC_INSTALL_DIR/bin:'$PATH'\" >> ~/.profile
      else
        echo "MD5 hash check error. exit"
        exit 1
      fi
    }
  fi
}

: "install $QEMU_COMMAND and related packages" && {
  if type $QEMU_COMMAND > /dev/null 2>&1; then
    echo "$QEMU_COMMAND already exists. skip install."
  else
    sudo apt-get update
    sudo apt-get install -y qemu-system-arm libpython2.7 libncurses5
  fi
}

: "install boost library" && {
  sudo apt-get update
  sudo apt-get install -y libboost-dev libboost-system-dev libboost-regex-dev libboost-filesystem-dev libboost-program-options-dev libxerces-c-dev
}

exit 0
