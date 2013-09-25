mainModule = angular.module "meducationFrontEnd"

mainModule.factory "votesService", ($http) ->
  {
    post: (vote) ->
      liked = if vote.liked then 1 else 0
      params = "item[id]=#{vote.id}&item[type]=#{vote.type}&liked=#{liked}"
      $http.post "/my/votes", encodeURI params
  }
