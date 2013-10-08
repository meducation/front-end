mainModule = angular.module 'meducationFrontEnd'

mainModule.factory 'votesService', ($http) ->
  {
    post: (vote) ->
      liked = if vote.liked then 1 else 0
      params = {
        'vote[item_id]': vote.item_id
        'vote[item_type]': vote.item_type
        'vote[liked]': liked
      }
      $http.post '/votes', {}, { params: params }

    put: (vote) ->
      liked = if vote.liked then 1 else 0
      params = {
        'vote[liked]': liked
      }
      $http.put "/votes/#{vote.vote_id}", {}, { params: params }

    delete: (vote) ->
      $http.delete "/votes/#{vote.vote_id}"
  }
