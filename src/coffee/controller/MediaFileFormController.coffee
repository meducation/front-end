mainModule = angular.module 'meducationFrontEnd'

mediaFileFormControllerFunction = ($rootScope, $scope) ->

  $scope.isFormSubmissionDisabled = true

  # Receive the original file URL from the MediaFileUploadController
  unbind = $rootScope.$on 'originalfileurlchange', (event, url) ->
    $scope.originalFileUrl = url
    $scope.isFormSubmissionDisabled = false

  # Prevent memory leaks, see: http://stackoverflow.com/a/19498009/2820224
  $scope.$on 'destroy', unbind

mediaFileFormControllerFunction.$inject = ['$rootScope', '$scope']
mainModule.controller 'mediaFileFormController', mediaFileFormControllerFunction
