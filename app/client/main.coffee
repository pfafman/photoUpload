
@ImagesHandle = Meteor.subscribeWithPagination "photos", 
        timestamp: -1
    ,
        20

Meteor.startup ->
    console.log("Meteor Start on Client")
    #console.log("URL:",document.URL)
    if /mobile/i.test(navigator.userAgent)
        console.log('Mobile Device')
        $ ->
            FastClick.attach document.body

        $(window).on "orientationchange", ->
            landscape = window.orientation is 90 or window.orientation is -90
            console.log("orientationchange", window.orientation, landscape)
            Session.set("landscape", landscape)
                
    else
        console.log("Not a mobile device", window)
