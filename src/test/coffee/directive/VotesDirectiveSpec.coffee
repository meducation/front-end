describe 'Votes Directive', ->

  directiveScope = null
  stubbedServicePost = null
  promise = null
  element = null

  # These are globals present in the existing website codebase.
  # We don't care about them for now, other than they are interacted with.
  window.Meducation =
    UI:
      wiggle: ->
    showAlert: ->

  window.mixpanel =
    track: ->

  directiveMarkup = '''<div data-med-voter
                            data-med-voter-id="1"
                            data-med-voter-type="MediaFile"
                            data-med-voter-rating="0"/>'''

  beforeEach ->

    # The meducationTemplates module contains a module for each template in
    # JS form (run 'grunt html2js' then see tmp/js/Templates.js).
    module 'meducationFrontEnd', 'meducationTemplates'
    inject ($compile, $rootScope, votesService, $q, $templateCache) ->

      # The argument in this call to the cache is a key mapped to
      # the HTML string that is the resulting template.
      template = $templateCache.get 'templates/votes.html'
      # The directive expects the template at this URL so add it as a key
      # and set the value to be the HTML string.
      $templateCache.put '/assets/votes.html', template

      stubbedServicePost = sinon.stub votesService, 'post'
      promise = $q.defer().promise

      spyOn window.Meducation.UI, 'wiggle'
      spyOn window.Meducation, 'showAlert'
      spyOn window.mixpanel, 'track'

      element = $compile(directiveMarkup)($rootScope)

      $rootScope.$digest()

      directiveScope = element.scope()

  afterEach ->
    stubbedServicePost.restore()

  it 'should have the score initialised to 0', ->
    expect(directiveScope.ratingText).toBe '+0'

  describe 'Up-voting', ->

    beforeEach ->
      promise.success = (callback) ->
        callback()

      spyOn(promise, 'success').andCallThrough()
      stubbedServicePost.returns promise

      directiveScope.upVote()

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
      expect(directiveScope.votedUp).toBeTruthy()

    it 'should set votedDown to false so that both buttons are not selected', ->
      expect(directiveScope.votedUp).toBeDefined()
      expect(directiveScope.votedDown).toBeFalsy()

    it 'should set the correct vote number when voted up', ->
      expect(directiveScope.ratingText).toBe '+1'

    it 'should set votedUp to false when clicked again', ->
      directiveScope.upVote 1, 'MediaFile'

      expect(directiveScope.votedUp).toBeFalsy()

    it 'should set the score back to 0 when clicked again', ->
      directiveScope.upVote 1, 'MediaFile'

      expect(directiveScope.ratingText).toBe '+0'

    it 'should decrease the score by 2 when voting down after voting up ', ->
      directiveScope.downVote 1, 'MediaFile'

      expect(directiveScope.ratingText).toBe '-1'

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

      directiveScope.downVote()

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
      expect(directiveScope.votedDown).toBeTruthy()

    it 'should set votedUp to false so that both buttons are not selected', ->
      expect(directiveScope.votedUp).toBeDefined()
      expect(directiveScope.votedUp).toBeFalsy()

    it 'should set the correct vote number when voted down', ->
      expect(directiveScope.ratingText).toBe '-1'

    it 'should set votedDown to false when clicked again', ->
      directiveScope.downVote 1, 'MediaFile'

      expect(directiveScope.votedDown).toBeFalsy()

    it 'should set the score back to 0 when clicked again', ->
      directiveScope.downVote 1, 'MediaFile'

      expect(directiveScope.ratingText).toBe '+0'

    it 'should increase the score by 2 when voting up after voting down', ->
      directiveScope.upVote 1, 'MediaFile'

      expect(directiveScope.ratingText).toBe '+1'

    it 'should animate the button', ->
      expect(window.Meducation.UI.wiggle).toHaveBeenCalled()

    it 'should not show the share to Facebook overlay', ->
      expect(window.Meducation.showAlert).not.toHaveBeenCalled()

    it 'should track the vote action', ->
      expect(window.mixpanel.track).toHaveBeenCalledWith 'Action: Voted',
      {liked: false, type: 'MediaFile'}
