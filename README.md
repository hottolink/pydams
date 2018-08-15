# Python bindings around DAMS: Geocoding Tool for Japanese Address

## 概要
* [ジオコーダDAMS(Distributed Address Matching System)](http://newspat.csis.u-tokyo.ac.jp/geocode/modules/dams/index.php?content_id=1)のPython bindingです
* 日本国内の住所文字列をジオコーディングすることができます
    * 正規化：都道府県，市区町村，…に分割した上で，代表表記に変換
    * 変換：住所を経緯度に変換
* DAMSは，[東京大学空間情報科学研究センターが提供する「CSVアドレスマッチングサービス」および「シンプルジオコーディング実験」](http://newspat.csis.u-tokyo.ac.jp/geocode)にて開発されたソフトウェアです．高速・高精度なジオコーディングを実現します

## 動作環境
* Python 2.7.x/3.6.x での動作を確認済みです
* 2.7.xの文字型はstr型ではなくunicode型を採用しています

## インストール
* まず，DAMSのインストールを行ってください
	* [本家からダウンロード](http://newspat.csis.u-tokyo.ac.jp/geocode/modules/dams/index.php?content_id=5) または 同梱のファイル(`../dams/dams-*.tgz`)を展開
	* インストールの手順は，DAMSに同梱のREADMEを参照してください
	* 本packageでは，共有ライブラリ(`dams.so`) のみを使用します
	  ヘッダファイルおよび，DAMSに同梱のサンプルプログラムは使用しません
* 次に，本packageのインストールを行ってください．手順は以下の通りです

```
git clone https://github.com/hottolink/pydams.git
cd pydams
# ビルド，テスト，インストールを実行
make all
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

## ライセンス
* 本packageは Apache License Version 2.0 に準拠します
* 本packageを使用する場合は，DAMSのライセンスに従う必要があります．別途ご確認ください
