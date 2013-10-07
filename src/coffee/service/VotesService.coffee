mainModule = angular.module "meducationFrontEnd"

mainModule.factory "votesService", ($http) ->
  {
    post: (vote) ->
      liked = if vote.liked then 1 else 0
      params = "vote[item_id]=#{vote.item_id}
      &vote[item_type]=#{vote.item_type}&liked=#{liked}"
      # XXX: Multiline string is to confirm to style guidelines
      # but introduces unwanted spaces.
      $http.post "/votes", encodeURI params.replace(/\ /g, '')

    put: (vote) ->
      liked = if vote.liked then 1 else 0
      params = "vote[liked]=#{liked}"
      $http.put "/votes/#{vote.vote_id}", encodeURI params

    delete: (vote) ->
      $http.delete "/votes/#{vote.vote_id}"
  }
