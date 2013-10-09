mainModule = angular.module 'meducationFrontEnd'

mainModule.controller 'votesController', ($scope, votesService) ->

  $scope.upVote = (itemId, itemType) ->
    promise = votesService.post({
      item_id: itemId, item_type: itemType, liked: true
    })
    promise.success ->
