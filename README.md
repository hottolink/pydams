# Python bindings around DAMS: Geocoding Tool for Japanese Address

## 概要
* [ジオコーダDAMS(Distributed Address Matching System)](http://newspat.csis.u-tokyo.ac.jp/geocode/modules/dams/index.php?content_id=1)のPython bindingです
* 日本国内の住所文字列をジオコーディングすることができます
    * 正規化：都道府県，市区町村，…に分割した上で，代表表記に変換
    * 変換：住所を経緯度に変換
* DAMSは，[東京大学空間情報科学研究センターが提供する「CSVアドレスマッチングサービス」および「シンプルジオコーディング実験」](http://newspat.csis.u-tokyo.ac.jp/geocode)にて開発されたソフトウェアです．高速・高精度なジオコーディングを実現します

## 動作環境
* Python 2.7.x/3.6.x での動作を確認しています
	* 2.7.xの文字型は，str型ではなくunicode型を採用しています
* DAMS Ver. 4.3.4 での動作を確認しています

## インストール
* まず，DAMSのインストールを行います．次に，Python binding(=本package: `pydams`)のインストールを行います．

### DAMSのインストール
* CentOS 7.4 でのインストール手順を紹介します．
* お使いの環境ではうまくいかないかもしれません．その場合は，DAMSに同梱のREADMEを参照してください．

1. 適当な作業ディレクトリに移動します．
   DAMSを[ダウンロード](http://newspat.csis.u-tokyo.ac.jp/geocode/modules/dams/index.php?content_id=5) して，ディレクトリ直下に解凍します．

```
wget http://newspat.csis.u-tokyo.ac.jp/download/dams-4.3.4.tgz
tar -xzvf dams-4.3.4.tgz
```

2. パッチを適用します(※)．パッチファイルは，本リポジトリに同梱されています．

```
git clone https://github.com/hottolink/pydams.git
patch -d ./dams-4.3.4 -p1 < ./pydams/patch/dams-4.3.4.diff
```

※ このパッチにより，例外処理に関するバグが修正されます．

3. ビルドを行います．共有ライブラリ(`libdams-4.3.4.so`)が生成されます．

```
cd dams-4.3.4
./configure; make
```

4. 生成された共有ライブラリをインストールして，キャッシュに登録します．

```
sudo make install
sudo ldconfig
ldconfig -v | grep dams
# 以下のように表示されれば，正常にインストールできています
>>> libdams-4.3.4.so -> libdams.so
```

5. 地域語辞書をビルドしてインストールします．

```
make dic
sudo make install-dic
```

### Python bindingのインストール
1. Python binding(=本package)をリポジトリからクローンして，ビルド・インストールを実行します．

```
cd ../
# パッチ適用時にclone済みの場合は省略
[ ! -d 'pydams' ] && git clone https://github.com/hottolink/pydams.git
cd pydams
# ビルド・テスト・インストールを実行
make all
# 一部の環境ではテストに失敗することがあるようです．この場合はインストールのみ実行してください
make install
```

2. インストール結果を確認します．`pydams` package が表示されれば，成功です．

```
pip freeze | grep pydams
>>> pydams==1.0.4
```

## 使用方法
* importしたジオコーダを初期化した上で，`geocode()` または `geocode_simplify()` に住所文字列を渡してください
	* `geocode()`：住所階層（都道府県，市区町村，…）ごとに分割された住所構造を返却
	* `geocode_simplify()`：全階層を連結した住所構造を返却

```
from pydams import DAMS
from pydams.helpers import pretty_print

DAMS.init_dams()
address = u"千代田区"

# geocode() method
geocoded = DAMS.geocode(address)
pretty_print(geocoded)

# geocode_simplify() method
geocoded = DAMS.geocode_simplify(address)
pretty_print(geocoded)
```

* レスポンスは以下のようになります

```
# geocode() method
score: 3
candidates: 1
	candidate: 0, address level: 3
		address:東京都, lat:35.6894989014, long:139.691635132
		address:千代田区, lat:35.6939315796, long:139.753540039

# geocode_simplify() method
score: 3
candidates: 1
	candidate: 0, address level: 3
		address:東京都千代田区, lat:35.6939315796, long:139.753540039
```

* 住所構造はdictionary形式になっています．dictionaryの内容は以下の通りです

```
score: ジオコーディングがどの程度成功したかを表すスコア．1~5の値
tail: クエリ文字列を先頭から住所として解析した結果、残った部分文字列
candidates: ジオコーディングにより得られた住所候補．複数の候補が存在する場合は2件以上を返す
candidates[i]: 住所要素リスト．都道府県->市区町村->...->街区 の順に格納
candidates[i][j]: 住所要素を表すdictionary
    name: 住所要素の名称．例：東京都
    level: 住所レベル．1~7の値．例：1
    x: 経度
    y: 緯度

# 住所要素の詳しい説明は，DAMSの公式ドキュメントを参照ください
http://newspat.csis.u-tokyo.ac.jp/geocode/modules/dams/index.php?content_id=4
```

* `pydams.helpers` には補助関数が定義されています．docstringを確認の上，適宜ご利用ください

## コンテナ化
* Dockerコンテナ [python:3.6.10](https://hub.docker.com/_/python) での動作を確認しています．
  `docker/Dockerfile` を参考にしてください．

## 謝辞
* 本リポジトリは，東京大学空間情報科学研究センターによる[ジオコーダDAMS(Distributed Address Matching System)](http://newspat.csis.u-tokyo.ac.jp/geocode/modules/dams/index.php?content_id=1)を弊社内でより使いやすくする目的で開発しました．
  このような便利かつ有用なツールを無償で公開して下さっている東京大学 空間情報科学研究センターに感謝申し上げます。
* DAMSプログラムのパッチを提供いただいた [Sangwhan Moon氏](https://www.sangwhan.com/) に感謝いたします。

## ライセンス
* 本packageおよびDAMSプログラムのパッチファイルは Apache License Version 2.0 に準拠します
* 本packageを使用する場合は，DAMSのライセンスに従う必要があります．別途ご確認ください
