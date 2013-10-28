exports.getVote = (request, response) ->
  response.render 'votes.html'

exports.postVote = (request, response) ->
  # Respond to a certain test vote as if the user is not logged-in
  if request.query.vote.item_id is '30299'
    response.send 403
  else
    response.json {
      "vote": {
        "id": 13172,
        "user_id": 2,
        "liked": true,
        "item": {
          "type": "media_file",
          "id": 8
        }
      }
    }

exports.putVote = (request, response) ->
  response.json {
    "vote": {
      "id": 13172,
      "user_id": 2,
      "liked": false,
      "item": {
        "type": "media_file",
        "id": 8
      }
    }
  }

exports.deleteVote = (request, response) ->
  response.json {

  }