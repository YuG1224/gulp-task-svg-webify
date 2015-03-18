gulp = require "gulp"
foreach = require "gulp-foreach"
svgmin = require "gulp-svgmin"
iconfont = require "gulp-iconfont"
consolidate = require "gulp-consolidate"
concat = require "gulp-concat"
del = require "del"
rs = require("run-sequence").use(gulp)
webserver = require "gulp-webserver"

options =
  fontName: "webfont"
  className: "wf"
  startCodepoint: 0xF001

# minify
gulp.task "minify", () ->
  return gulp.src ["src/svg/*.svg"]
    .pipe foreach (stream, file) ->
      filename = file.path.replace file.base, ""
      stream.pipe svgmin()
        .pipe concat filename
    .pipe gulp.dest "dist/svg"

# webify
gulp.task "webify", () ->
  return gulp.src ["dist/svg/*.svg"]
    .pipe iconfont options
    .on "codepoints", (codepoints, options) ->
      for val in codepoints
        val.codepoint = val.codepoint.toString(16).toUpperCase()
      engine = "handlebars"
      consolidateOptions =
        glyphs: codepoints,
        fontName: options.fontName
        fontPath: "../fonts/"
        className: options.className

      gulp.src "src/template.css"
        .pipe consolidate engine, consolidateOptions
        .pipe concat "#{options.fontName}.css"
        .pipe gulp.dest "dist/css/"

      gulp.src "src/template.html"
        .pipe consolidate engine, consolidateOptions
        .pipe concat "index.html"
        .pipe gulp.dest "dist/"

    .pipe gulp.dest "dist/fonts/"

# watch
gulp.task "watch", () ->
  gulp.watch ["src/svg/*.svg"], () ->
    rs "clean", "minify", "webify"

# webserver
gulp.task "webserver", ["compile", "watch"], () ->
  gulp.src "dist"
    .pipe webserver
      livereload: true

# clean
gulp.task "clean", (done) ->
  del ["dist/*/*"], done

# initialize
gulp.task "initialize", (done) ->
  del ["dist"], done

# compile
gulp.task "compile", (done) ->
  rs "initialize", "minify", "webify", done
