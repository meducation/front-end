mainModule = angular.module 'meducationFrontEnd'

syllabusItemsControllerFunction = ($scope, syllabusItemsService) ->

  $scope.init = ->
    $scope.items = syllabusItemsService.query()

  $scope.showSelect = (level) ->
    level?.children?.length > 0

  $scope.updateMeshHeadingIds = ->
    $scope.meshHeadingIds = []
    level = 0
    while $scope["selected#{level}"]?.id
      $scope.meshHeadingIds.push $scope["selected#{level}"].id
      level += 1

    $scope.meshHeadingIds = $scope.meshHeadingIds.join ','

syllabusItemsControllerFunction.$inject = ['$scope', 'syllabusItemsService']
mainModule.controller 'syllabusItemsController', syllabusItemsControllerFunction