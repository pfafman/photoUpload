
Package.describe({
  summary: "Meteor Wrapper for JavaScript-Load-Image"
});

Package.on_use(function (api) {

    api.add_files('lib/load-image.min.js', 'client');

    /*
    api.add_files([
        'lib/load-image.js',
        'lib/load-image-exif-map.js',
        'lib/load-image-exif.js',
        'lib/load-image-ios.js',
        'lib/load-image-meta.js',
        'lib/load-image-orientation.js',
        'lib/load-image.js'
        ], 'client');
    */

    if (api.export) {
        api.export('loadImage');
    }
     
});