
Session.setDefault("imagesUpdated", null)

Template.cameraTest.created = ->
    console.log("cameraTest created", PhotoUploader)
    PhotoUploader.setOptions
        serverUploadMethod: "submitPhoto"
        takePhotoButtonLabel: "Take Photo"
        uploadButtonLabel: "Save Image"
        editTitle: true
        editCaption: true
        allowCropping: true
        resizeMaxHeight:        400
        resizeMaxWidth:         350

Template.cameraTest.rendered = ->
    console.log('cameraTest.rendered')
    photoUploader?.reset()
         
Template.cameraTest.helpers

    haveImages: ->
        Photos.find().count() > 0

    imagesReady: ->
        console.log("imagesReady", ImagesHandle.ready())
        ImagesHandle.ready()

    imageCount: ->
        Photos.find().count()


teTime = 0
showingMenu = false


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

    "click #toggle-btn": (e) ->
        console.log('toggle-btn', $('#content-container').width(), $('#content-container').css('margin-left'))
        if showingMenu
            $('#content-container').css('margin-left', '')
            showingMenu = false
        else
            offset = $('body').width() - 40
            $('#content-container').css('margin-left', "#{offset}px")
            showingMenu = true


@carouselInit = ->
    if ImagesHandle.ready()
        $(".owl-carousel").owlCarousel
            #navigation : true # Show next and prev buttons
            slideSpeed : 300
            paginationSpeed : 400
            singleItem:true
            transitionStyle : "fade"
            #itemsScaleUp:true
            autoHeight: true
            lazyLoad: true
            lazyFollow: true
            lazyLoadCallback: (img) ->
                if img
                    Photos.findOne(img.data("src"))?.src
            afterLazyLoad: (base, elm) ->
                if elm
                    elm.find(".hide").removeClass("hide")
    else
        console.log("Images not ready")

   
Template.carousel.helpers
    images: ->
        if ImagesHandle.ready()
            if $(".owl-carousel").data?('owlCarousel')?
                $(".owl-carousel").data('owlCarousel').destroy()
            Photos.find().rewind()
            Meteor.defer ->
                carouselInit()
                #Session.set("imagesUpdated", new Date())
            pc = Photos.find {},
                fields:
                    src: 0
                sort:
                    timestamp: -1
            pc.fetch()



Template.carouselImage.helpers
    size: ->
        Math.round(@filesize/1000) + " kb"



WhiteSpinner = options:
    lines: 13 # The number of lines to draw
    length: 8 # The length of each line
    width: 3 # The line thickness
    radius: 12 # The radius of the inner circle
    corners: 1 # Corner roundness (0..1)
    rotate: 0 # The rotation offset
    direction: 1 # 1: clockwise, -1: counterclockwise
    color: "#fff" # #rgb or #rrggbb
    speed: 1.2 # Rounds per second
    trail: 60 # Afterglow percentage
    shadow: false # Whether to render a shadow
    hwaccel: false # Whether to use hardware acceleration
    className: "whiteSpinner" # The CSS class to assign to the spinner
    zIndex: 2e9 # The z-index (defaults to 2000000000)
    top: "auto" # Top position relative to parent in px
    left: "auto" # Left position relative to parent in px

Template.whiteSpinner.rendered = ->
    target = document.getElementById("white-spinner")
    spinner = new Spinner(WhiteSpinner.options).spin(target)





