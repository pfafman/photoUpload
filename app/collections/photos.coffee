# Make sure collection is global with '@'

@Photos = new Meteor.Collection('photos')

Meteor.methods
    submitPhoto: (photoAttributes, options) ->
        photo = _.extend _.pick(photoAttributes, "src", "name", "filesize", "orientation"),
            timestamp: new Date().getTime()
        
        try   
            Photos.insert(photo)
        catch error
            console.log("Error on photo insert", error)
            result =
                error: 
                    reason: "Error on new photo insert"
            return result
