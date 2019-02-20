#!/bin/bash -u

DOC_SH=$(basename $0)                               # このスクリプト自体の名前
SCRIPT_DIR=$(cd $(dirname $0) && pwd)               # このスクリプトが存在するディレクトリの絶対パス
ARIAWASE_DIR=$(cd ${SCRIPT_DIR}/../ariawase && pwd) # ariawase ディレクトリの絶対パス
BIN_DIR=${ARIAWASE_DIR}/bin                         # bin ディレクトリの絶対パス
SRC_DIR=${ARIAWASE_DIR}/src                         # src ディレクトリの絶対パス
VBFILTER_DIR=$(cd ${SCRIPT_DIR}/../vbfilter && pwd) # vbfilter ディレクトリの絶対パス
HEADER="${RM_SH}: "                                 # シェルスクリプトから表示するメッセージのヘッダ
SPACER="$(echo "${HEADER}" | sed -r "s/./ /g")"     # HEADER と同じ文字数のスペース

if [ ! -d ${SRC_DIR}/$1 ]
	echo "${HEADER}src/$1 not found" >&2
	exit 1
fi

if [ -e ${SRC_DIR}/$1/Doxyfile ]; then
	cp ${VBFILTER_DIR}/Doxyfile.linux ${SRC_DIR}/$1/Doxyfile
	sed -i -r "s/PROJECT_NAME\s*=.+/PROJECT_NAME           = $1\n/g" ${SRC_DIR}/$1/Doxyfile # PROJECT_NAME を変更
	sed -i -r "s/INPUT\s*=.+/INPUT                  = .\/\n/g" ${SRC_DIR}/$1/Doxyfile       # INPUT をカレントディレクトリに変更
fi

cd ${SRC_DIR}/$1
doxygen
