
previewImage = null
previewImageListeners = new Deps.Dependency()

Template.photoUpload.created = ->
    previewImage = null
    

Template.photoUpload.helpers

    havePreviewImage: ->
        previewImageListeners.depend()
        previewImage?

    previewImage: ->
        previewImageListeners.depend()
        previewImage


Template.photoUpload.events
    "click #take-photo-button": (e) ->
        e.preventDefault()
        console.log("upload-photo clicked")
        $("#photo").trigger('click')

    "change #photo": (e) ->
        file = e.target.files[0]
        console.log("onchange", file)
        loadImage.parseMetaData file, (data) ->
            console.log("parseMetaData", data, data?.exif?.get?('Orientation'))

            loadImage file, (img) ->
                console.log("loadImage Callback", img)
                #document.body.appendChild(img)
                previewImage =
                    name: file.name.split('.')[0]
                    src: img.toDataURL() #img.src #reSizeImageMP(img, metadata.Orientation)
                    filesize: file.size
                    newImage: true
                    orientation: data?.exif?.get?('Orientation') or 1
                previewImageListeners.changed()
            ,
                maxHeight: 300 # Options
                orientation: data?.exif?.get?('Orientation') or 1
                canvas: true
        

    #
    #"drop #photo-button": (e) ->
    #    e.stopPropagation()
    #    e.preventDefault()
    #    file = e.dataTransfer.files[0]
    #    console.log("drop event", file)
    #    handleFile(file)

    #"dragenter #photo-button": (e) ->
    #    e.stopPropagation()
    #    e.preventDefault()
    #    console.log("dragenter event")

    #"dragover #photo-button": (e) ->
    #    e.stopPropagation()
    #    e.preventDefault()


cropCords = null
previewImageCropListeners = new Deps.Dependency()

Template.photoUploadPreview.created = ->
    cropCords = null

Template.photoUploadPreview.rendered = ->
    console.log("Template.photoUploadPreview.rendered")
    Meteor.defer ->
        console.log("Defer")
        $('#photoUploadPreview').Jcrop(
            onSelect: (cords) ->
                console.log("onSelect", cords)
                cropCords = cords
                previewImageCropListeners.changed()
            #onChange: (cords) ->
            #    console.log("onChange", cords)
            #    cropCords = cords
            onRelease: ->
                console.log("onRelease")
                cropCords = null
                previewImageCropListeners.changed()
        ).parent().on "click", (event) ->
            event.preventDefault()


Template.photoUploadPreview.helpers
    size: ->
        Math.round(@filesize/1000) + " kb"

    imagePartSelected: ->
        previewImageCropListeners.depend()
        cropCords?

Template.photoUploadPreview.events

    "click #crop-photo-button": (e) ->
        e.preventDefault()
        console.log("crop", e)
        img = $('#photoUploadPreview')
        if not cropCords or not img
            alert("You have to select a part of the image to crop")
        else
            newImg = loadImage.scale img[0],
                left: cropCords.x
                top: cropCords.y
                sourceWidth: cropCords.w
                sourceHeight: cropCords.h
                #minWidth: img.parent().width()
                canvas: true
            previewImage.src = newImg.src || newImg.toDataURL()
            previewImageListeners.changed()
            cropCords = null
            previewImageCropListeners.changed()

    "click #upload-photo-button": (e) ->
        e.preventDefault()
        newPhoto = $('#photoUploadPreview')
        console.log("upload-photo-button clicked", newPhoto)
        rec =
            name: newPhoto.attr('name')
            filesize: newPhoto.attr('src').length
            orientation: newPhoto.attr('orientation')
            src: newPhoto.attr('src')

        console.log(rec)
        Meteor.call "submitPhoto", rec, (error, result) ->
            if error
                CoffeeAlerts.error(error.reason)
            else
                previewImage = null
            previewImageListeners.changed()




