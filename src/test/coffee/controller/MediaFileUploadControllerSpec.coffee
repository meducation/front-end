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

  describe 'On file Upload Done', ->
    it 'should emit the external file URL on the root scope', ->

      externalFileUrl = 'http://my.external.server.com/uploads/image.jpg'
      xml = """
        <PostResponse>
          <Location>http://my.external.server.com/uploads/image.jpg</Location>
          <Bucket>my-bucket</Bucket>
          <Key>uploads/image.jpg</Key>
          <ETag>1709b592c7e504e467a5fc2c918ed477</ETag>
        </PostResponse>
      """
      spyOn _$rootScope_, '$emit'

      $scope.$emit 'fileuploaddone', { result: xml }

      expect(_$rootScope_.$emit)
        .toHaveBeenCalledWith 'externalfileurlchange', externalFileUrl