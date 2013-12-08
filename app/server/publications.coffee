

Meteor.publish "photoSummary", (limit) ->
    Photos.find {},
        sort: 
            timestamp: -1
        limit: limit


Meteor.publish "photos", (limit) ->
    Photos.find {},
        sort: 
            timestamp: -1
        limit: limit