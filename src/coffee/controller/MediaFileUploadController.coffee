mainModule = angular.module 'meducationFrontEnd'

#
# This controller configures and reacts to events from the jQuery File upload
# angular plugin:
# https://github.com/blueimp/jQuery-File-Upload/blob/master/js/jquery.fileupload-angular.js
#
mediaFileUploadControllerFunction = ($rootScope, $scope, $element) ->

  $scope.statusOKDisplay = 'none'
  $scope.statusFailDisplay = 'none'

  $scope.options = {
    # Set to null to avoid parseerror messages for IE < 10 browsers.
    # We cannot get the XML response back from S3 via these browsers anyway :(
    dataType: null
    autoUpload: true
  }

  # These events are callback options from the jQuery File Upload plugin at
  # https://github.com/blueimp/jQuery-File-Upload/wiki/Options#callback-options
  $scope.$on 'fileuploadprogressall', (event, data) ->
    $scope.progressWidth = parseInt data.loaded/data.total*100, 10

  $scope.$on 'fileuploaddone', (event, data) ->
    nameParts = data.files[0].name.split(".")
    ext = nameParts[nameParts.length - 1]
    $scope.fileName = "original.#{ext}"
    originalFileUrl = "#{data.url}#{$element.find('#s3_key').val()}"
      .replace '${filename}', $scope.fileName

    # Publish the url via the event name (first argument) so that the
    # MediaFileFormController can pick it up and set the hidden field:
    # original_file_url
    $rootScope.$emit 'originalfileurlchange', originalFileUrl

    $scope.progressWidth = 0
    $scope.statusOKDisplay = 'inline'

  $scope.$on 'fileuploadfail', (event, data) ->
    $scope.uploadError = data.textStatus
    $scope.statusFailDisplay = 'inline'

mediaFileUploadControllerFunction.$inject = ['$rootScope', '$scope', '$element']
mainModule.controller 'mediaFileUploadController',
  mediaFileUploadControllerFunction
