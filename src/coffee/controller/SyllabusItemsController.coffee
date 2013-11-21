mainModule = angular.module 'meducationFrontEnd'

syllabusItemsControllerFunction = ($scope, syllabusItemsService) ->
  $scope.init = ->
    $scope.items = syllabusItemsService.query()

syllabusItemsControllerFunction.$inject = ['$scope', 'syllabusItemsService']
mainModule.controller 'syllabusItemsController', syllabusItemsControllerFunction