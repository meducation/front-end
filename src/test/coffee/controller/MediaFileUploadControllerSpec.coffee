describe 'Media File Upload Controller', ->

  controller = null
  _$rootScope_ = null
  $scope = null

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($rootScope, $controller, $compile) ->
      _$rootScope_ = $rootScope.$new()
      $scope = $rootScope.$new()
      formMarkup = """
        <form>
          <input id='s3_key' type='hidden' value='uploads/image.jpg'/>
        </form>
      """
      $element = $compile(formMarkup)(_$rootScope_)

      controller = $controller 'mediaFileUploadController',
        {
          $rootScope: _$rootScope_
          $scope: $scope
          $element: $element
        }

  describe 'Initialisation', ->
    it 'should be defined', ->
      expect(controller).not.toBeNull()

    it 'should set the correct options for the blueimp.fileupload plugin', ->
      expect($scope.options).toEqual { dataType: null, autoUpload: true }

    it 'should not have a progress width set', ->
      expect($scope.progressWidth).toBeUndefined()

  describe 'On file Upload Done', ->

    beforeEach ->
      spyOn _$rootScope_, '$emit'
      $scope.$emit 'fileuploaddone', {
        url: 'http://my.external.server.com/'
        files: [{ name: 'image.jpg'}]
      }

    it 'should emit the external file URL on the root scope', ->
      externalFileUrl = 'http://my.external.server.com/uploads/image.jpg'

      expect(_$rootScope_.$emit)
        .toHaveBeenCalledWith 'externalfileurlchange', externalFileUrl

    it 'should set the progress bar width to 0', ->
      expect($scope.progressWidth).toBe 0

    it 'should set the file name', ->
      expect($scope.fileName).toBe 'image.jpg'

  describe 'On file Upload Progress', ->
    it 'should set the progress bar width', ->
      $scope.$emit 'fileuploadprogressall', { loaded: 30, total: 90 }

      expect($scope.progressWidth).toBe 33