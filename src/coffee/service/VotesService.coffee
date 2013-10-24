mainModule = angular.module 'meducationFrontEnd'

votesServiceFunction = ($http, apiURI) ->
  {
  post: (vote) ->
    liked = if vote.liked then 1 else 0
    params = {
      'vote[item_id]': vote.item_id
      'vote[item_type]': vote.item_type
      'vote[liked]': liked
    }
    $http.post "#{apiURI}/votes", {}, { params: params }

  put: (vote) ->
    liked = if vote.liked then 1 else 0
    params = {
      'vote[liked]': liked
    }
    $http.put "#{apiURI}/votes/#{vote.vote_id}", {}, { params: params }

  delete: (vote) ->
    $http.delete "#{apiURI}/votes/#{vote.vote_id}"
  }

votesServiceFunction.$inject = ['$http', 'apiURI']
mainModule.factory 'votesService', votesServiceFunction