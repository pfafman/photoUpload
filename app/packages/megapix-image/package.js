
Package.describe({
  summary: "Meteor Wrapper for iOS Imagefile Megapixel which fixed subsampling issue in iOS 6+"
});

Package.on_use(function (api) {
  
  api.add_files('src/megapix-image.js', 'client');
  api.add_files('src/jpeg.js', 'client');
  
  if (api.export) {
        api.export('MegaPixImage');
        api.export('JPEG');
    }
});