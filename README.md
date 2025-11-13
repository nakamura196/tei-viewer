# TEI/XML Viewer

TEI XMLファイルとDTS Collections形式のコレクションを閲覧するためのWebビューアです。

## 機能

- **ホームページ** (index.html)
  - コレクションURLまたは文書URLを入力して開く
  - 縦書き/横書きモードの選択

- **コレクションビューア** (collection.html)
  - DTS Collections API形式のJSONを読み込み
  - タイトル、ID、識別子での検索機能
  - 各アイテムのTEI XMLへのリンク
  - IIIF ManifestへのリンクとXMLダウンロード

- **文書ビューア** (item.html)
  - OpenSeadragonを使用したIIIF画像表示
  - TEI XMLファイルからのテキストと画像の同期表示
  - ページナビゲーション
  - 行単位のアノテーション表示（画像上の枠線表示）
  - 全ページ横断検索機能
  - ページ内テキスト検索
  - 縦書きモード対応（右から左への読み進め）

## 使い方

### 1. ローカルサーバーの起動

ビューアを使用するには、ローカルのHTTPサーバーが必要です：

```bash
# Pythonの場合
python3 -m http.server 8000

# または Node.js の http-server を使用
npx http-server -p 8000
```

### 2. ブラウザでアクセス

ブラウザで以下のURLを開きます：

```
# ホームページ
http://localhost:8000/

# または直接index.htmlを開く
http://localhost:8000/index.html
```

### 3. URLパラメータでの直接アクセス

#### コレクションを開く

```
# index.htmlから
http://localhost:8000/?u=https://example.com/dts_collections.json

# または collection.html に直接
http://localhost:8000/collection.html?u=https://example.com/dts_collections.json
```

URLパラメータ:
- `u`: DTS Collections JSON形式のコレクションURL

#### 文書を開く

```
# index.htmlから
http://localhost:8000/?file=001-01.xml&page=3&vertical=true

# または item.html に直接
http://localhost:8000/item.html?file=001-01.xml&page=3&vertical=true
```

URLパラメータ:
- `file`: 表示するTEI XMLファイル名またはURL（必須）
- `page`: 初期表示ページ番号（オプション、デフォルト: 1）
- `vertical`: 縦書きモード（`true`で有効、デフォルト: false）
- `u`: コレクションURL（オプション、collection.htmlへの戻るリンクを生成）

**例:**

```
# 横書きモードでページ1から表示
http://localhost:8000/item.html?file=001-01.xml

# 縦書きモードでページ3から表示
http://localhost:8000/item.html?file=001-01.xml&page=3&vertical=true

# 外部URLから読み込み
http://localhost:8000/item.html?file=https://example.com/tei/001-01.xml&vertical=true
```

## ファイル構成

```
├── index.html          # ホームページ（ランディングページ）
├── collection.html     # コレクション一覧ページ
├── item.html           # 文書ビューアページ
└── README.md           # このファイル
```

## DTS Collections API

このビューアはDistributed Text Services (DTS) Collections API v1-alpha1 形式のJSONに対応しています。

### JSON形式例

```json
{
  "@context": "https://distributed-text-services.github.io/specifications/context/1-alpha1.json",
  "@id": "https://example.com/api/dts/collections.json",
  "@type": "Collection",
  "title": "Collection Title",
  "description": "Collection Description",
  "totalItems": 10,
  "member": [
    {
      "@id": "https://example.com/api/dts/collection/001",
      "@type": "Resource",
      "title": "Document Title",
      "description": "Document Description",
      "dts:dublincore": {
        "dc:identifier": "001",
        "dc:title": "Document Title",
        "dc:publisher": "Publisher Name",
        "dc:format": "application/tei+xml",
        "dc:language": "bo"
      },
      "dts:download": "001.xml",
      "dts:extensions": {
        "iiif:manifest": "https://example.com/iiif/2/001/manifest"
      }
    }
  ]
}
```

**注意:** `dts:download` に相対パスを指定した場合、コレクションJSONのベースURLからの相対パスとして解決されます。

## TEI XML形式

このビューアは以下の構造を持つTEI XMLファイルに対応しています：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
  <teiHeader>
    <fileDesc>
      <titleStmt>
        <title>文書タイトル</title>
      </titleStmt>
      <publicationStmt>
        <idno type="UUID">{UUID}</idno>
      </publicationStmt>
    </fileDesc>
  </teiHeader>
  <text>
    <body>
      <p>
        <pb n="1"/>
        <lb corresp="#z1_l1" n="1"/>テキスト内容
      </p>
    </body>
  </text>
  <facsimile>
    <surface xml:id="page-0" n="1" lrx="width" lry="height">
      <graphic url="IIIF Image URL"/>
      <zone xml:id="z1_l1" ulx="x1" uly="y1" lrx="x2" lry="y2"/>
    </surface>
  </facsimile>
</TEI>
```

### 主要な要素

- `<pb>`: ページ区切り（page break）
- `<lb>`: 行区切り（line break）、`corresp`属性でzoneと対応
- `<surface>`: 画像ページの情報
- `<graphic>`: IIIF画像URL
- `<zone>`: 行の座標情報（ulx, uly, lrx, lry）

## CORS設定について

外部URLからコレクションやTEI XMLファイルを読み込む場合、サーバー側でCORSを有効にする必要があります。

## カスタマイズ

### スタイルのカスタマイズ

各HTMLファイルの `<style>` タグ内のCSSを編集することで、外観をカスタマイズできます。

### フォントのカスタマイズ

item.html はデフォルトでチベット語フォント（Noto Serif Tibetan）を使用しています。他の言語やフォントに変更する場合は、CSSの `font-family` を編集してください。

## ブラウザ互換性

- モダンブラウザ（Chrome, Firefox, Safari, Edge）に対応
- JavaScript が有効である必要があります
- Fetch API を使用しています

## 技術スタック

- HTML5
- CSS3（グリッドレイアウト、Flexbox）
- JavaScript（Vanilla JS、ES6+）
- [OpenSeadragon](https://openseadragon.github.io/) - IIIF画像ビューア
- [Noto Serif Tibetan](https://fonts.google.com/noto/specimen/Noto+Serif+Tibetan) - Webフォント

## ライセンス

© 2025 TEI/XML Viewer
