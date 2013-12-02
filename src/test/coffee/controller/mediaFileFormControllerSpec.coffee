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

  describe 'On Original File URL Change', ->
    extnernalFileUrl = 'http://my.original.server.com/uploads/image.jpg'

    beforeEach ->
      _$rootScope_.$emit 'originalfileurlchange', extnernalFileUrl

    it 'should set the local originalFileURL scope variable', ->
      expect($scope.originalFileUrl).toBe extnernalFileUrl

    it 'should enable form submission', ->
      expect($scope.isFormSubmissionDisabled).toBeFalsy()
