#!/bin/bash -u

RM_SH=$(basename $0)                                # このスクリプト自体の名前
SCRIPT_DIR=$(cd $(dirname $0) && pwd)               # このスクリプトが存在するディレクトリの絶対パス
ARIAWASE_DIR=$(cd ${SCRIPT_DIR}/../ariawase && pwd) # ariawase ディレクトリの絶対パス
BIN_DIR=${ARIAWASE_DIR}/bin                         # bin ディレクトリの絶対パス
SRC_DIR=${ARIAWASE_DIR}/src                         # src ディレクトリの絶対パス
HEADER="${RM_SH}: "                                 # シェルスクリプトから表示するメッセージのヘッダ
SPACER="$(echo "${HEADER}" | sed -r "s/./ /g")"     # HEADER と同じ文字数のスペース

if [ -e ${BIN_DIR}/$1 ]; then
	rm ${BIN_DIR}/$1
else
	echo "${HEADER}bin/$1 not found" >&2
	exit 1
fi

if [ -e ${SRC_DIR}/$1/ ]; then
	rm -r ${SRC_DIR}/$1/
else
	echo "${HEADER}src/$1 not found" >&2
	exit 1
fi
