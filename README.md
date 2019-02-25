# vba-mng
VBAソースコード管理用ツール

## できること（やりたいこと）

| できること（やりたいこと） | 実現方法 |
| :------------------------- | :------- |
| マクロ有効ExcelワークブックのVBAソースコードを、Gitで管理 | `ariawase/vbac.wsf` でエクスポート |
| Doxygenで文書生成 | `doxygen-vb-filter/vbfilter.awk` を適用 |

## 使い方

### 初めにやること

このリポジトリを`clone`します。

```
$ git clone --recursive https://github.com/lie/vba-mng.git
$ cd vba-mng
```

### 既存のExcelファイルを管理する場合

以下を実行します。

```
$ make init project=/path/to/file.xlsm
```

これにより、`ariawase/bin/` に `file.xlsm` がコピーされます。また、`file.xlsm` 内のソースコードを任意でエクスポートできます。

### ファイル無しで、新しくプロジェクトを始める場合

以下を実行します。

```
$ make init project=<new-project-name>
```

これにより、`ariawase/bin/` に `new-project-name.xlsm` が生成されます。

### Doxygen文書生成

`make init` を実行してから、以下を実行します。

```
$ make doc project=<project-name>
```

これにより、`ariawase/src/project-name/html/index.html` にDoxygen文書が生成されます。
同時に生成される `ariawase/src/project-name/Doxyfile` は、好みに合わせて変更することが出来ます。

### プロジェクトの削除

以下を実行すると、`ariawase/bin/project-name` と `ariawase/src/project-name` が削除されます。

```
make rm project=<project-name>
```

### VBAソースコードの管理

以下のコマンドを実行すると、ワークブックからエクスポートします。この時、`ariawase/bin/` 内の全ファイルからエクスポートされます。

```
make decombine
```

逆に、`ariawase/src/` 内のソースファイルからワークブックにインポートするには、以下を実行します。

```
make combine
```

エクスポート/インポートには、`vbac.wsf` を使用しています。`vbac.wsf` の詳細な仕様については、製作者様の解説を参照してください。

[いげ太の日記: Ariawase v0.6.0 解説（vbac 編）](http://igeta-diary.blogspot.com/2014/03/what-is-vbac.html)

## ToDo

- `make [init|rm|doc] project=hoge`の入力について
	- `hoge` でサジェストが利かない
		- ディレクトリ構成を見直し、`.xlsm`ファイルを`Makefile`と同じディレクトリに置けるようにする
		- **`vbac.wsf` の変更が必要**
	- `project=` が長い
- `init` について
	- `file=<existing file>` と `project=<new project>` に分ける
- 他
	- 各`scripts/*.sh`のエラーメッセージのヘッダは、スクリプトファイル名でなくてもいい
	- `.dcm`に対応
	- `combine`、`decombine` の実行時、タイムスタンプを比較して、上書きされる前に警告を表示
