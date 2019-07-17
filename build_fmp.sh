#!/usr/bin/env bash
set -eu

if [ ! -v SCRIPTS_DIR ]; then
  SCRIPTS_DIR=$(cd $(dirname $0);pwd)
fi

if [ ! -v WORK_DIR ]; then
  # if directory doesn't exist, it will be made
  if [ ! -d $HOME/workdir ]; then
    echo "$WORK_DIR doesn't exists. working directory 'toppers_workdir' will be made in current directory."
    WORK_DIR=$(pwd)/toppers_workdir
    mkdir -p $WORK_DIR
  else
    WORK_DIR=$HOME/workdir
  fi
fi

CFG_NAME=cfg
CFG_VERSION=1.9.6
CFG_FILE_NAME=${CFG_NAME}-${CFG_VERSION}.tar.gz
CFG_FILE_PATH=${WORK_DIR}/${CFG_FILE_NAME}
CFG_DOWNLOAD_URL="http://www.toppers.jp/download.cgi/${CFG_FILE_NAME}"
CFG_DIR=$WORK_DIR/${CFG_NAME}-${CFG_VERSION}

FMP_PACKAGE_NAME=RPi64Toppers
FMP_PACKAGE_DIR=$WORK_DIR/$FMP_PACKAGE_NAME
FMP_DOWNLOAD_URL="https://github.com/YujiToshinaga/$FMP_PACKAGE_NAME.git"
FMP_DIR=$FMP_PACKAGE_DIR/fmp
FMP_CFG_DIR="$FMP_DIR/cfg/cfg"

LIBDIR=/usr/lib/x86_64-linux-gnu

: "setup tools (compiler, emulator, etc.)" && {
  $SCRIPTS_DIR/setup_tools.sh
  . $HOME/.profile
}

: "build a TOPPERS configurator if it doesn't exist" && {
  if [ -e $CFG_DIR/cfg/cfg ]; then
    echo "${CFG_NAME}-${CFG_VERSION} is already exist. skip build it."
  else
    wget $CFG_DOWNLOAD_URL -O $CFG_FILE_PATH
    mkdir -p $CFG_DIR
    tar xvf $CFG_FILE_PATH -C $CFG_DIR --strip-components 2
    cd $CFG_DIR
    nkf -e -Lu --overwrite configure
    ./configure --with-libraries=$LIBDIR
    make
  fi
}

: "build a kernel" && {
  cd $WORK_DIR
  if [ -d $FMP_PACKAGE_DIR ]; then
    echo "$FMP_PACKAGE_DIR directory already exists, so it will be renamed."
    mv $FMP_PACKAGE_DIR $FMP_PACKAGE_DIR.$(date +%Y%m%d_%H%M%S)
  fi

  git clone $FMP_DOWNLOAD_URL $FMP_PACKAGE_DIR
  mkdir -p $FMP_CFG_DIR
  cd $FMP_CFG_DIR
  ln -sf $CFG_DIR/cfg/cfg cfg
  cd $FMP_DIR
  mkdir build; cd build
  perl ../configure -T rpi_arm64_gcc
  make fmp.bin
}

exit 0
