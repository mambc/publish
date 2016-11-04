var gulp = require("gulp");
var jshint = require("gulp-jshint");
var uglify = require("gulp-uglify");
var concat = require("gulp-concat");
var rename = require("gulp-rename");
var jsonminify = require('gulp-jsonminify');

var files = "./src/js/*.js";
var data = "./src/data/*.geojson";

gulp.task("lint", function() {
	gulp.src(files)
		.pipe(jshint())
		.pipe(jshint.reporter("default"));
});

gulp.task("dist", function() {
	gulp.src(files)
		.pipe(concat("./dist"))
		.pipe(rename("publish.min.js"))
		.pipe(uglify())
		.pipe(gulp.dest("./dist"));
});

gulp.task("minify", function() {
    gulp.src(data)
    	.pipe(jsonminify())
        .pipe(gulp.dest("./dist/data"));
});

gulp.task("default", function() {
	gulp.watch(files, function(evt) {
		gulp.run("lint", "dist");
	});
});
