mainModule = angular.module 'meducationFrontEnd'

mediaFileUploadControllerFunction = ($rootScope, $scope) ->

  $scope.options = {
    dataType: 'xml'
    autoUpload: true
  }

  $scope.$on 'fileuploadprogressall', (event, data) ->
    $scope.progressWidth = parseInt data.loaded/data.total*100, 10

  $scope.$on 'fileuploaddone', (event, data) ->
    externalFileUrl = decodeURIComponent $(data.result).find('Location').text()
    $scope.fileName = externalFileUrl.split('/').pop()

    $rootScope.$emit 'externalfileurlchange', externalFileUrl

    $scope.progressWidth = 0

mediaFileUploadControllerFunction.$inject = ['$rootScope', '$scope']
mainModule.controller 'mediaFileUploadController',
  mediaFileUploadControllerFunction