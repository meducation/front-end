mainModule = angular.module 'meducationFrontEnd'

syllabusItemsControllerFunction = ($scope, syllabusItemsService) ->
  $scope.init = ->
    $scope.items = syllabusItemsService.query()

  $scope.showSelect = (level) ->
    if level then level.children.length > 0

syllabusItemsControllerFunction.$inject = ['$scope', 'syllabusItemsService']
mainModule.controller 'syllabusItemsController', syllabusItemsControllerFunction