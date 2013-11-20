
#
#  imageUpload Control
#


newImages = []

imagesListeners = new Deps.Dependency()

triggerClick = (id) ->
    console.log("triggerClick", id, element)
    element = document.getElementById(id)
    if document.createEvent
        evt = document.createEvent("HTMLEvents")
        evt.initEvent("click", true, true)
        element.dispatchEvent evt
    else
        element.click()
    

reSizeImage = (img) ->
    maxHeight = 256
    r = maxHeight / Math.max(img.width,img.height)
    w = Math.round(img.width * r)
    h = Math.round(img.height * r)
    canvas = document.createElement("canvas")
    canvas.width = w
    canvas.height = h
    canvas.getContext("2d").drawImage(img,0,0,w,h)
    if canvas.toDataURLHD?
        canvas.toDataURLHD("image/jpeg")
    else
        canvas.toDataURL("image/jpeg")


reSizeImageMP = (img, orientation) ->
    megaPixImg = new MegaPixImage(img)
    canvas = document.createElement("canvas")
    console.log("reSizeImageMP", orientation)
    megaPixImg.render canvas, 
        maxWidth: 512
        maxHeight: 512
        orientation: orientation or 1
    canvas.toDataURL("image/jpeg")

mpHandleFile = (file) ->
    megaPixImg = new MegaPixImage(file)
    canvas = document.createElement("canvas")
    megaPixImg.render canvas, 
        maxWidth: 1024
        maxHeight: 1024
    url = canvas.toDataURL("image/jpeg")
    console.log("URL", url)
    newImages.unshift
        name: file.name.split('.')[0]
        src: url
        filesize: url.length
        newImage: true
    imagesListeners.changed()

handleFile = (file) ->
    if file.type.match(/image.*/)
        reader = new FileReader()
        reader.onload = (event) ->
            console.log("file loaded", event)
            readExifData event.target.result, (metadata) ->
                console.log("Unshift new image", metadata?.Orientation, metadata)
                img = new Image()
                img.src = event.target.result
                newImages.unshift
                    name: file.name.split('.')[0]
                    src: img.src #reSizeImageMP(img, metadata.Orientation)
                    filesize: file.size
                    newImage: true
                    orientation: metadata.Orientation or 1
                imagesListeners.changed()
        reader.readAsDataURL(file)
    else 
        alert("Bad file type, #{file.type}")


###
    Creates and returns a blob from a data URL (either base64 encoded or not).
    @param {string} dataURL The data URL to convert.
    @return {Blob} A blob representing the array buffer data.
###
dataURLToBlob = (dataURL) ->
  BASE64_MARKER = ";base64,"
  if dataURL.indexOf(BASE64_MARKER) is -1
    parts = dataURL.split(",")
    contentType = parts[0].split(":")[1]
    raw = parts[1]
    return new Blob([raw],
      type: contentType
    )
  parts = dataURL.split(BASE64_MARKER)
  contentType = parts[0].split(":")[1]
  raw = window.atob(parts[1])
  rawLength = raw.length
  uInt8Array = new Uint8Array(rawLength)
  i = 0

  while i < rawLength
    uInt8Array[i] = raw.charCodeAt(i)
    ++i
  new Blob [uInt8Array],
    type: contentType


readExifData = (dataUrl, callback) ->
    blob = dataURLToBlob(dataUrl)
    JPEG.readExifMetaData blob, (error, metaData) ->
        if error
            console.log("readExifData error", error)
            metaData = {}
        callback(metaData)

#Template.cameraTest.helpers

Template.cameraTest.created = ->
    newImages = []
    #if not imagesListeners
    #    @imagesListeners = new Deps.Dependency()

Template.cameraTest.events
    "click #photo-button": (e) ->
        e.preventDefault()
        console.log("upload-photo clicked")
        $("#photo").trigger('click')
        #triggerClick("photo")

    "touchstart #photo": (e) ->
        console.log("photo click")
        #alert("photo click?")

    "change #photo": (e) ->
        file = e.target.files[0]
        console.log("onchange", file)
        handleFile(file)

    "submit form": (e) ->
        e.preventDefault()
        newPhoto = $('#photo')
        $('.newImage').each (index, elm) ->
            rec = 
                name: elm.name
            oldSize = elm.src.length
            #rec.src = elm.src #
            #rec.src = reSizeImage(elm)
            rec.src = reSizeImageMP(elm, $(elm).attr('orientation')) 
            rec.filesize = rec.src.length
            rec.orientation = $(elm).attr('orientation')
            #elm.src = rec.src
            Meteor.call "submitPhoto", rec, (error, result) ->
                if error
                    CoffeeAlerts.error(error.reason)
            console.log('submit', oldSize, rec.filesize)
        #newImages = []
        imagesListeners.changed()
        #console.log("newImages", newImages)
    

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
    

Template.cameraTest.helpers
    "newImages": ->
        imagesListeners.depend()
        newImages

    "haveNewImages": ->
        imagesListeners.depend()
        newImages.length > 0

    "images": ->
        Photos.find {},
            sort:
                timestamp: -1

Template.image.helpers
    "size": ->
        Math.round(@filesize/1000) + " kb"








