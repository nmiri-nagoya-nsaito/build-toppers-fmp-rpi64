# build-toppers-fmp-rpi64
build scripts for TOPPERS/FMP on Raspberry Pi with AArch64

# これは何か
[Raspberry Pi3 向け TOPPERS/FMP カーネル](https://github.com/YujiToshinaga/RPi64Toppers)のための開発環境を構築するためのシェルスクリプトです．

# 必要なもの

Docker（およびDocker Compose）が必要です．事前にインストールしておく必要があります．

https://www.docker.com/

また，このスクリプトはDocker上のLinux環境(Ubuntu Xenial)で動作確認済みです．
Docker環境は[こちら](https://github.com/nmiri-nagoya-nsaito/docker-toppers)を利用します．

# 使い方

## Docker環境の準備

```
$ git clone https://github.com/nmiri-nagoya-nsaito/docker-toppers.git
```
カレントディレクトリに docker-toppers という名称のディレクトリができます．

## Dockerイメージをビルドしてbashシェルを起動

```
$ cd docker-toppers
$ ./start_shell.sh
```
これで開発用のLinuxコンテナが作られ，その中のbashシェルに入ります．

### (注)イメージのビルド途中でエラーが発生する場合

Ubuntu Xenial のイメージをベースにしてイメージを構築していますが，
古いイメージがマシンに残っている状態で実行するとイメージのビルド過程でエラーが発生することがあります．
その場合は --no-cache オプションをつけてイメージの再作成をしてください．
その上で start_shell.sh を実行します．

```
# エラーが発生する場合はこれを試してみる
$ docker-compose build --no-cache
$ ./start_shell.sh
```

## Linuxコンテナから抜ける

シェルを終了すればコンテナから出ることができます．
再度コンテナに入る場合も start_shell.sh スクリプトを実行します．

```
$ exit
```

## このスクリプトをダウンロード

このリポジトリで公開しているファイルをダウンロードします．
作業はコンテナ内のBashシェルで行います．

```
$ cd workdir
$ git clone https://github.com/nmiri-nagoya-nsaito/build-toppers-fmp-rpi64.git
```

## TOPPRERS/FMPカーネルのビルド

```
$ cd build-toppers-fmp-rpi64
$ ./build_fmp.sh
```

成功すると， 実行ファイルとして $HOME/workdir/RPi64Toppers/fmp/build/fmp.bin ができます．

## 実行ファイルの位置

コンテナを起動するとホームディレクトリ直下に workdir というディレクトリができます．
またホスト上のカレントディレクトリ直下に workdir というディレクトリもできます．
それら2つのディレクトリはコンテナとホストとで同じ場所をさしており，ファイルを両者で共有するのに使うことができます．

Raspberry Pi を起動する場合， ホスト上から見える workdir/RPi64Toppers/fmp/build/fmp.bin をSDカードにコピーして使います．
使い方について詳細は https://github.com/YujiToshinaga/RPi64Toppers を参照してください．

