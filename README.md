# vba-mng
VBAソースコード管理用ツール

## ToDo

- `make [init|rm|doc] project=hoge`の入力について
	- `hoge` でサジェストが利かない
		- ディレクトリ構成を見直し、`.xlsm`ファイルを`Makefile`と同じディレクトリに置けるようにする
		- **`vbac.wsf` の変更が必要**
	- `project=` が長い
- `init` について
	- `file=<existing file>` と `project=<new project>` に分ける