describe 'Media File Form Controller', ->

  controller = null
  _$rootScope_ = null
  $scope = null

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($rootScope, $controller) ->
      _$rootScope_ = $rootScope.$new()
      $scope = _$rootScope_.$new()

      controller = $controller 'mediaFileFormController',
      {
        $rootScope: _$rootScope_,
        $scope: $scope
      }

  describe 'Initialisation', ->
    it 'should be defined', ->
      expect(controller).not.toBeNull()

    it 'should set the form submit button to be disabled', ->
      expect($scope.isFormSubmissionDisabled).toBeTruthy()

  describe 'On External File URL Change', ->
    extnernalFileUrl = 'http://my.external.server.com/uploads/image.jpg'

    beforeEach ->
      _$rootScope_.$emit 'externalfileurlchange', extnernalFileUrl

    it 'should set the local externalFileURL scope variable', ->
      expect($scope.externalFileUrl).toBe extnernalFileUrl

    it 'should enable form submission', ->
      expect($scope.isFormSubmissionDisabled).toBeFalsy()