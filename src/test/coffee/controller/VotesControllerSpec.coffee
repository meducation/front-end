describe 'Votes Controller', ->

  controller = null
  $scope = null
  stubbedServicePost = null
  promise = null

  # These are globals present in the existing website codebase.
  # We don't care about them for now, other than they are interacted with.
  window.Meducation =
    UI:
      wiggle: ->
    showAlert: ->

  window.mixpanel =
    track: ->

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($rootScope, $controller, votesService, $q) ->
      $scope = $rootScope.$new()
      $scope.id = 1
      $scope.type = 'MediaFile'
      # Set the intial score, currently stored in the DOM.
      # It must be set before the controller loads as it reads the DOM
      # on intialisation.
      spyOn($.fn, 'data').andReturn 0

      controller = $controller 'votesController', { $scope: $scope }

      stubbedServicePost = sinon.stub votesService, 'post'
      promise = $q.defer().promise

      spyOn window.Meducation.UI, 'wiggle'
      spyOn window.Meducation, 'showAlert'
      spyOn window.mixpanel, 'track'

  afterEach ->
    stubbedServicePost.restore()

  it 'should be defined', ->
    expect(controller).not.toBeNull()

  # TODO: Move this to the directive spec
  xit 'should have the score initialised to 0', ->
    expect($scope.ratingText).toBe '+0'

  describe 'Up-voting', ->

    beforeEach ->
      promise.success = (callback) ->
        callback()

      spyOn(promise, 'success').andCallThrough()
      stubbedServicePost.returns promise

      $scope.upVote()

    it 'should call the votes service to post an up-vote', ->
      sinon.assert.calledWith stubbedServicePost, {
        item_id: 1
        item_type: 'MediaFile'
        liked: true
      }

    it 'should act on the resolved promise when successful', ->
      expect(promise.success).toHaveBeenCalled()

    it 'should set votedUp to true so that the view can act on the result', ->

      # The view uses votedUp to set the selected class against the button
      expect($scope.votedUp).toBeTruthy()

    it 'should set votedDown to false so that both buttons are not selected', ->
      expect($scope.votedUp).toBeDefined()
      expect($scope.votedDown).toBeFalsy()

    it 'should set the correct vote number when voted up', ->
      expect($scope.ratingText).toBe '+1'

    it 'should set votedUp to false when clicked again', ->
      $scope.upVote 1, 'MediaFile'

      expect($scope.votedUp).toBeFalsy()

    it 'should set the score back to 0 when clicked again', ->
      $scope.upVote 1, 'MediaFile'

      expect($scope.ratingText).toBe '+0'

    it 'should decrease the score by 2 when voting down after voting up ', ->
      $scope.downVote 1, 'MediaFile'

      expect($scope.ratingText).toBe '-1'

    it 'should animate the button', ->
      expect(window.Meducation.UI.wiggle).toHaveBeenCalled()

    it 'should show the share to Facebook overlay', ->
      expect(window.Meducation.showAlert).toHaveBeenCalled()

    it 'should track the vote action', ->
      expect(window.mixpanel.track).toHaveBeenCalledWith 'Action: Voted',
        {liked: true, type: 'MediaFile'}

  describe 'Down-voting', ->

    beforeEach ->
      promise.success = (callback) ->
        callback()

      spyOn(promise, 'success').andCallThrough()
      stubbedServicePost.returns promise

      $scope.downVote()

    it 'should call the votes service to post a down-vote', ->
      sinon.assert.calledWith stubbedServicePost, {
        item_id: 1
        item_type: 'MediaFile'
        liked: false
      }

    it 'should act on the resolved promise when successful', ->
      expect(promise.success).toHaveBeenCalled()

    it 'should set votedDown to true so that the view can act on the result', ->

      # The view uses votedDown to set the selected class against the button
      expect($scope.votedDown).toBeTruthy()

    it 'should set votedUp to false so that both buttons are not selected', ->
      expect($scope.votedUp).toBeDefined()
      expect($scope.votedUp).toBeFalsy()

    it 'should set the correct vote number when voted down', ->
      expect($scope.ratingText).toBe '-1'

    it 'should set votedDown to false when clicked again', ->
      $scope.downVote 1, 'MediaFile'

      expect($scope.votedDown).toBeFalsy()

    it 'should set the score back to 0 when clicked again', ->
      $scope.downVote 1, 'MediaFile'

      expect($scope.ratingText).toBe '+0'

    it 'should increase the score by 2 when voting up after voting down', ->
      $scope.upVote 1, 'MediaFile'

      expect($scope.ratingText).toBe '+1'

    it 'should animate the button', ->
      expect(window.Meducation.UI.wiggle).toHaveBeenCalled()

    it 'should not show the share to Facebook overlay', ->
      expect(window.Meducation.showAlert).not.toHaveBeenCalled()

    it 'should track the vote action', ->
      expect(window.mixpanel.track).toHaveBeenCalledWith 'Action: Voted',
        {liked: false, type: 'MediaFile'}
