mainModule = angular.module 'meducationFrontEnd'

mediaFileUploadControllerFunction = ($rootScope, $scope) ->

  $scope.options = {
    dataType: 'xml'
    autoUpload: true
  }

  $scope.$on 'fileuploadprogressall', (event, data) ->
    #TODO: Update UI progress bar

  $scope.$on 'fileuploaddone', (event, data) ->
    externalFileUrl = $(data.result).find('Location').text()
    $rootScope.$emit 'externalfileurlchange', externalFileUrl

mediaFileUploadControllerFunction.$inject = ['$rootScope', '$scope']
mainModule.controller 'mediaFileUploadController', mediaFileUploadControllerFunction