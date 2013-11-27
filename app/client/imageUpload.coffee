
photoUploader = null

Template.cameraTest.created = ->
    if not photoUploader?
        photoUploader = new PhotoUploadHandler
            serverUploadMethod: "submitPhoto"
            takePhotoButtonLabel: "Take Photo"
            uploadButtonLabel: "Save Image"
            editTitle: true
            editCaption: true

Template.cameraTest.rendered = ->
    #FastClick.attach(document.getElementById('button-test-fc'))
    photoUploader?.reset()
    
    $(".owl-carousel").owlCarousel
        #navigation : true # Show next and prev buttons
        slideSpeed : 300
        paginationSpeed : 400
        singleItem:true
        #itemsScaleUp:true
        autoHeight: true
        autoPlay: 5000
        #rewindNav: false
        #rewindSpeed: 200

Template.cameraTest.helpers

    haveImages: ->
        Photos.find().count() > 0

    imageCount: ->
        Photos.find().count()

    images: ->
        Photos.find {},
            sort:
                timestamp: -1

teTime = 0

Template.cameraTest.events
    "touchend #button-test": (e) ->
        teTime = Date.now()

    "touchend #button-test-fc": (e) ->
        teTime = Date.now()

    "click #button-test": (e) ->
        cTime = Date.now()
        diff = cTime - teTime
        console.log("Test #{diff}")
        #Meteor.defer ->
        #    $('#button-test').parent().focus()

    "click #button-test-fc": (e) ->
        cTime = Date.now()
        diff = cTime - teTime
        console.log("Fastclick Test #{diff}")

    "click .btn": (e) ->
        #Meteor.defer ->
        #    $('#button-test-fc').parent().focus()



Template.image.helpers
    size: ->
        Math.round(@filesize/1000) + " kb"








