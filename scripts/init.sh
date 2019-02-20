#!/bin/bash -u

INIT_SH=$(basename $0)                             # このスクリプト自体の名前
SCRIPT_DIR=$(cd $(dirname $0) && pwd)              # このスクリプトが存在するディレクトリの絶対パス
ARIAWASE_DIR=$(cd ${SCRIPT_DIR}/../ariawase && pwd) # ariawase ディレクトリの絶対パス
BIN_DIR=${ARIAWASE_DIR}/bin                        # bin ディレクトリの絶対パス
SRC_DIR=${ARIAWASE_DIR}/src                        # src ディレクトリの絶対パス
VBF_DIR=${ARIAWASE_DIR}/vbfilter                   # vbfilter ディレクトリの絶対パス
HEADER="${INIT_SH}: "                              # シェルスクリプトから表示するメッセージのヘッダ
SPACER="$(echo "${HEADER}" | sed -r "s/./ /g")"    # HEADER と同じ文字数のスペース

# 現状、Cygwin のみ対応のため、Cygwin 以外から実行したら強制終了
RESULT=0
OUTPUT=$(type cygpath 2>&1 > /dev/null) || RESULT=$? 
if [ ! "$RESULT" = "0" ]; then
	echo "${HEADER}command 'cygpath' not found." >&2
	exit 1
fi

WSF_WINDOWS_PATH=$(cygpath -w ${ARIAWASE_DIR}/vbac.wsf) # vbac.wsf のWindows形式フルパス

# 引数がない場合は終了
if [ $# -lt 1 ]; then
	echo "${HEADER}Missing argument (a .xlsm file or new project name)" >&2
	exit 1
fi

# bin ディレクトリがなければ作成
if [ ! -e ${BIN_DIR} ]; then
	mkdir ${BIN_DIR}
fi

if [ -e $1 ]; then # .xlsm ファイルが指定された場合、bin/ にコピーしてdecombine（拡張子のチェックはしない）
	NEW_FILE=$(basename $1)

	# 引数がディレクトリだったら終了
	if [ -d $1 ]; then
		echo "${HEADER}$1 is directory." >&2
		exit 1
	fi

	# bin/ に同名のファイルが既に存在したら終了
	if [ -e ${BIN_DIR}/${NEW_FILE} ]; then
		echo "${HEADER}bin/${NEW_FILE} is already exists." >&2
		exit 1
	fi

	# src/ に同名のディレクトリが存在したら警告
	if [ -e ${SRC_DIR}/${NEW_FILE} ]; then
		echo "${HEADER}src/${NEW_FILE} is already exists."
		echo "${SPACER}you run \`cscript //nologo vbac.wsf decombine\`,"
		echo "${SPACER}VBA source files in src/${NEW_FILE} will be overwrited with files in $1."
		echo
	fi

	# 指定されたファイルを bin/ にコピーした後、任意で decombine を実行
	cp $1 ${BIN_DIR}
	echo "About to run \`cscript //nologo vbac.wsf decombine\`. This will overwrite existing VBA source files in 'src' directory."
	read -p "Do you want to proceed? [Y/n]: " ANSWER
	case $ANSWER in
		[Yy]* )
			cscript //nologo ${WSF_WINDOWS_PATH} decombine
			;;
		*)
			echo "Running \`vbac.wsf\` was skipped."
			echo "You can run \`cscript //nologo vbac.wsf decombine\` to export VBA source files from '"$1".xlsm'."
			;;
	esac

	# `vbac.wsh decombine` を実行していない場合、ディレクトリが生成されないため、シェルスクリプトから生成する必要がある
	if [ ! -e ${SRC_DIR}/${NEW_FILE} ]; then
		mkdir ${SRC_DIR}/${NEW_FILE}
	fi

	# Doxygen の準備
	#cp -r ${VBF_DIR} ${SRC_DIR}/${NEW_FILE}
	#mv ${SRC_DIR}/${NEW_FILE}/vbfilter/Makefile ${SRC_DIR}/${NEW_FILE}
	#sed -i -r "s/Doxyfile.linux/vbfilter\/Doxyfile.linux/g" ${SRC_DIR}/${NEW_FILE}/Makefile
	#sed -i -r "s/PROJECT_NAME\s+=.+/PROJECT_NAME = ${NEW_FILE}\n/g" ${SRC_DIR}/${NEW_FILE}/vbfilter/Doxyfile.linux
	#echo "Run \`make doc project=${NEW_FILE}\` in src/${NEW_FILE} to generate the Doxygen documents."
else # ファイルが存在しない場合、プロジェクト名として扱い、xlsmファイルをcombineで作成する
	NEW_FILE=$1".xlsm"

	# プロジェクト名に '/' は使用不能
	if [ $(echo "${NEW_FILE}" | grep "/") ]; then
		echo "${HEADER}The project name cannot contain slashes('/')." >&2
		exit 1
	fi

	# .xslm を付けて、src/ に同名のディレクトリが既に存在したら終了
	if [ -e ${SRC_DIR}/${NEW_FILE} ]; then
		echo "${HEADER}src/${NEW_FILE} is already exists." >&2
		exit 1
	fi

	# .xslm を付けて、bin/ に同名のファイルが既に存在したら終了
	if [ -e ${SRC_DIR}/${NEW_FILE} ]; then
		echo "${HEADER}bin/${NEW_FILE} is already exists." >&2
		exit 1
	fi

	# src/ にディレクトリを作成した後、任意で decombine を実行
	mkdir ${SRC_DIR}/${NEW_FILE}
	echo "About to run \`cscript //nologo vbac.wsf combine\`. This will overwrite existing VBA source files in .xlsm files."
	read -p "Do you want to proceed? [Y/n]: " ANSWER
	case $ANSWER in
		[Yy]* )
			cscript //nologo ${WSF_WINDOWS_PATH} combine
			;;
		*)
			echo "Running vbac.wsf was skipped."
			echo "You can run \`cscript //nologo vbac.wsf combine\` to generate '${NEW_FILE}'."
			;;
	esac

	# Doxygen の準備
	#cp -r ${VBF_DIR} ${SRC_DIR}/${NEW_FILE}
	#mv ${SRC_DIR}/${NEW_FILE}/vbfilter/Makefile ${SRC_DIR}/${NEW_FILE}
	#sed -i -r "s/Doxyfile.linux/vbfilter\/Doxyfile.linux/g" ${SRC_DIR}/${NEW_FILE}/Makefile
	#sed -i -r "s/PROJECT_NAME\s+=.+/PROJECT_NAME = ${NEW_FILE}\n/g" ${SRC_DIR}/${NEW_FILE}/vbfilter/Doxyfile.linux
	#echo "Run \`make doc project=${NEW_FILE}\` to generate the Doxygen documents."
fi