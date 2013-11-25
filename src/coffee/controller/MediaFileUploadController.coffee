mainModule = angular.module 'meducationFrontEnd'

mediaFileUploadControllerFunction = ($scope) ->

  $scope.isFormSubmissionDisabled = true

  $scope.init = (externalServerUrl) ->
    $scope.externalServerUrl = externalServerUrl

  $scope.options = {
    dataType: 'xml'
    autoUpload: true
  }

  $scope.$on 'fileuploadprogressall', (event, data) ->
    #TODO: Update UI progress bar
    console.log 'progress'

  $scope.$on 'fileuploaddone', (event, data) ->
    relativeFileUrl = $(data.result).find('Key').text()
    # TODO: emit these so that the other form controller can act on them
    $scope.externalFileUrl = "{$scope.externalServerUrl}/#{relativeFileUrl}"
    $scope.isFormSubmissionDisabled = false

mediaFileUploadControllerFunction.$inject = ['$scope']
mainModule.controller 'mediaFileUploadController', mediaFileUploadControllerFunction