mainModule = angular.module 'meducationFrontEnd'

mediaFileUploadControllerFunction = ($rootScope, $scope, $element) ->

  $scope.options = {
    # Set to null to avoid parseerror messages for IE < 10 browsers.
    # We cannot get the XML response back from S3 via these browsers anyway :(
    dataType: null
    autoUpload: true
  }

  $scope.$on 'fileuploadprogressall', (event, data) ->
    $scope.progressWidth = parseInt data.loaded/data.total*100, 10

  $scope.$on 'fileuploaddone', (event, data) ->
    $scope.fileName = data.files[0].name
    externalFileUrl = "#{data.url}#{$element.find('#s3_key').val()}"
      .replace '${filename}', $scope.fileName

    $rootScope.$emit 'externalfileurlchange', externalFileUrl

    $scope.progressWidth = 0

mediaFileUploadControllerFunction.$inject = ['$rootScope', '$scope', '$element']
mainModule.controller 'mediaFileUploadController',
  mediaFileUploadControllerFunction