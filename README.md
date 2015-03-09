# gulp-task-svg-webify

## Install

```bash
$ npm install -g gulp
$ npm install
```

## Compile

- Minify SVG
- Webify SVG

svgをminifyし、WebFont化します。

```bash
$ gulp compile
```

or

```bash
$ gulp minify   // minifyのみ
$ gulp webify   // webfont化のみ
```

## WebServer

上記のsample画面を配信するwebserverを起動します。

```bash
$ gulp webserver
```

[http://localhost:8000](http://localhost:8000) でwebfontを確認することが出来ます。

`src/svg/*.svg`の変更を監視して minify, webify を自動実行し、livereload機能によってブラウザを自動で更新します。
