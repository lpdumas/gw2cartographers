'use strict';

var watchify     = require('watchify');
var browserify   = require('browserify');
var gulp         = require('gulp');
var source       = require('vinyl-source-stream');
var buffer       = require('vinyl-buffer');
var gutil        = require('gulp-util');
var assign       = require('lodash.assign');
var sass         = require('gulp-ruby-sass');
var autoprefixer = require('gulp-autoprefixer');
var serve        = require('gulp-serve');

var customOpts = {
  entries: ['./app/js/app.js'],
  debug: true,
  transform: [["reactify", {'es6': true}]]
};

var opts = assign({}, watchify.args, customOpts);
var b    = watchify(browserify(opts));

gulp.task('js', bundle); // so you can run `gulp js` to build the file

// on any dep update, runs the bundler
b.on('update', bundle);
b.on('log', gutil.log); // output build logs to terminal

function bundle() {
  return b.bundle()
    // log errors if they happen
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source('bundle.js'))
       // Add transformation tasks to the pipeline here.
    .pipe(gulp.dest('./dist/js'))
}

gulp.task('styles', function() {
  return sass('./app/styles/', { style: 'expanded' })
  .on('error', gutil.log.bind(gutil, 'Style Error'))
  .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
  .pipe(gulp.dest('./dist/css/'));
})

gulp.task('copy', function() {
  gulp.src('./app/index.html')
  .pipe(gulp.dest('./dist'));

  gulp.src('./app/js/libs/*.js')
  .pipe(gulp.dest('./dist/js/libs'));
});

gulp.task('watch', function(){
  gulp.watch('./app/index.html', ['copy']);
  gulp.watch('./app/styles/*.sass', ['styles']);
})

gulp.task('serve', serve('dist'));

gulp.task('default', function(done) {
    gulp.start('js', 'styles', 'copy', 'watch', 'serve');
});