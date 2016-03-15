gulp = require 'gulp'

plumber = require 'gulp-plumber'
rename = require 'gulp-rename'

autoprefixer = require 'gulp-autoprefixer'
sourcemaps = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'

gulp.task 'styles', ->
	gulp.src 'src/styles/*.scss'
		.pipe plumber
			errorHandler: (error) ->
				console.log error.message
				this.emit 'end'
		.pipe sass()
		.pipe autoprefixer 'last 2 versions'
		.pipe gulp.dest 'dist/styles/'

gulp.task 'scripts', ->
	gulp.src 'src/scripts/*.coffee'
		.pipe plumber
			errorHandler: (error) ->
				console.log error.message
				this.emit 'end'
		.pipe sourcemaps.init()
		.pipe coffee {bare: true}
		.pipe sourcemaps.write()
		.pipe gulp.dest 'dist/scripts/'
		.pipe rename {suffix: '.min'}

gulp.task 'default', ->
	gulp.watch "src/styles/*.scss", ['styles']
	gulp.watch "src/scripts/*.coffee", ['scripts']