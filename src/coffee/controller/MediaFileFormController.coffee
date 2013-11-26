mainModule = angular.module 'meducationFrontEnd'

mediaFileFormControllerFunction = ($rootScope, $scope) ->

  $scope.isFormSubmissionDisabled = true

  unbind = $rootScope.$on 'externalfileurlchange', (event, url) ->
    $scope.externalFileUrl = url
    $scope.isFormSubmissionDisabled = false

  $scope.$on 'destroy', unbind

mediaFileFormControllerFunction.$inject = ['$rootScope', '$scope']
mainModule.controller 'mediaFileFormController', mediaFileFormControllerFunction