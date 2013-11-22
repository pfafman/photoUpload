
photoUploader = null

Template.cameraTest.created = ->
    if not photoUploader?
        photoUploader = new PhotoUploadHandler
            serverUploadMethod: "submitPhoto"
            takePhotoButtonLabel: "Take Photo"
            uploadButtonLabel: "Save Image"

Template.cameraTest.rendered = ->
    photoUploader?.reset()

Template.cameraTest.helpers

    haveImages: ->
        Photos.find().count() > 0

    imageCount: ->
        Photos.find().count()

    images: ->
        Photos.find {},
            sort:
                timestamp: -1

Template.image.helpers
    size: ->
        Math.round(@filesize/1000) + " kb"








