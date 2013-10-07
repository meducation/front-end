mainModule = angular.module "meducationFrontEnd"

mainModule.factory "votesService", ($http) ->
  {
    post: (vote) ->
      liked = if vote.liked then 1 else 0
      params = "vote[item_id]=#{vote.id}
      &vote[item_type]=#{vote.type}&liked=#{liked}"
      # XXX: Multiline string is to confirm to style guidelines
      # but introduces unwanted spaces.
      $http.post "/votes", encodeURI params.replace(/\ /g, '')
  }
