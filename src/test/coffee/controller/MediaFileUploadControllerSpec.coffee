describe 'Media File Upload Controller', ->

  controller = null
  _$rootScope_ = null
  $scope = null

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($rootScope, $controller) ->
      _$rootScope_ = $rootScope.$new()
      $scope = $rootScope.$new()

      controller = $controller 'mediaFileUploadController',
        {
          $rootScope: _$rootScope_
          $scope: $scope
        }

  describe 'Initialisation', ->
    it 'should be defined', ->
      expect(controller).not.toBeNull()

    it 'should set the correct options for the blueimp.fileupload plugin', ->
      expect($scope.options).toEqual { dataType: 'xml', autoUpload: true }

    it 'should not have a progress width set', ->
      expect($scope.progressWidth).toBeUndefined()

  describe 'On file Upload Done', ->

    beforeEach ->
      spyOn _$rootScope_, '$emit'
      xml = """
      <PostResponse>
        <Location>http://my.external.server.com/uploads%2Fimage.jpg</Location>
        <Bucket>my-bucket</Bucket>
        <Key>uploads/image.jpg</Key>
        <ETag>1709b592c7e504e467a5fc2c918ed477</ETag>
      </PostResponse>
      """
      $scope.$emit 'fileuploaddone', { result: xml }

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