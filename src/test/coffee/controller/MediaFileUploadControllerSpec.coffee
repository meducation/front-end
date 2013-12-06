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
        <form data-url-root='uploads/'>
          <input id='s3_key' type='hidden' />
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

    it 'should set the file upload OK status display property to none', ->
      expect($scope.statusOKDisplay).toBe 'none'

    it 'should set the file upload fail status display property to none', ->
      expect($scope.statusFailDisplay).toBe 'none'

  describe 'On File Added', ->

    beforeEach ->
      $scope.$emit 'fileuploadadd', {
        files: [{ name: 'image.jpg'}]
      }

    it 'should set the correct S3 key', ->
      expect($scope.s3_key)
        .toBe 'uploads/original.jpg'

    it 'should set the correct file name', ->
      expect($scope.fileName).toBe 'original.jpg'

  describe 'On File Upload Done', ->

    beforeEach ->
      spyOn _$rootScope_, '$emit'
      $scope.s3_key = 'uploads/original.jpg'
      $scope.$emit 'fileuploaddone', {
        url: 'http://my.original.server.com/'
      }

    it 'should emit the original file URL on the root scope', ->
      originalFileUrl = 'http://my.original.server.com/uploads/original.jpg'

      expect(_$rootScope_.$emit)
        .toHaveBeenCalledWith 'originalfileurlchange', originalFileUrl

    it 'should set the progress bar width to 0', ->
      expect($scope.progressWidth).toBe 0

    it 'should set the file upload OK status display property to inline', ->
      expect($scope.statusOKDisplay).toBe 'inline'

  describe 'On file Upload Progress', ->
    it 'should set the progress bar width', ->
      $scope.$emit 'fileuploadprogressall', { loaded: 30, total: 90 }

      expect($scope.progressWidth).toBe 33

  describe 'On File Upload Failure', ->

    beforeEach ->
      $scope.$emit 'fileuploadfail', { textStatus: 'parseerror' }

    it 'should set the file upload fail status display property to inline', ->
      expect($scope.statusFailDisplay).toBe 'inline'

    it 'should set the upload error to be the reason behind the failure', ->
      expect($scope.uploadError).toBe 'parseerror'
