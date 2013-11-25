describe 'Media File Upload Controller', ->

  controller = null
  $scope = null

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($rootScope, $controller) ->
      $scope = $rootScope.$new()

      controller = $controller 'mediaFileUploadController', { $scope: $scope }

  describe 'Initialisation', ->

    it 'should be defined', ->
      expect(controller).not.toBeNull()

    it 'should set the form submit button to be disabled', ->
      expect($scope.isFormSubmissionDisabled).toBeTruthy()

    it 'should set the external file URL when init is called', ->
      $scope.init 'http://my.external.server.com'

      expect($scope.externalServerUrl).toBe 'http://my.external.server.com'

    it 'should set the correct options for the blueimp.fileupload plugin', ->
      expect($scope.options).toEqual { dataType: 'xml', autoUpload: true }
