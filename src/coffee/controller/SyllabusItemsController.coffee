mainModule = angular.module 'meducationFrontEnd'

syllabusItemsControllerFunction = ($scope, syllabusItemsService) ->

  levels = [0 ,1, 2, 3, 4]

  $scope.init = ->
    $scope.items = syllabusItemsService.query()

  $scope.showSelect = (level) ->
    level?.children?.length > 0

  $scope.updateMeshHeadingIds = ->
    $scope.meshHeadingIds = []
    for level in levels
      if $scope["selected#{level}"]?.id
        $scope.meshHeadingIds.push $scope["selected#{level}"].id

    $scope.meshHeadingIds = $scope.meshHeadingIds.join ','

syllabusItemsControllerFunction.$inject = ['$scope', 'syllabusItemsService']
mainModule.controller 'syllabusItemsController', syllabusItemsControllerFunction