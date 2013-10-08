exports.postVote = (request, response) ->
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