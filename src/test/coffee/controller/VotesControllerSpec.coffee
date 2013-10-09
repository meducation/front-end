describe 'Votes Controller', ->

  controller = null
  $scope = null
  stubbedServicePost = null
  promise = null

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($rootScope, $controller, votesService, $q) ->
      $scope = $rootScope.$new()
      controller = $controller 'votesController', { $scope: $scope }
      stubbedServicePost = sinon.stub votesService, 'post'
      promise = $q.defer().promise

  afterEach ->
    stubbedServicePost.restore()

  it 'should be defined', ->
    expect(controller).not.toBeNull()

  it 'should call the votes service to post an up-vote', ->
    promise.success = ->
    stubbedServicePost.returns promise

    $scope.upVote 1, 'MediaFile'

    sinon.assert.calledWith stubbedServicePost, {
      item_id: 1
      item_type: 'MediaFile'
      liked: true
    }

  it 'should act on the resolved promise when successful', ->
    promise.success = ->
    spyOn(promise, 'success')
    stubbedServicePost.returns promise

    $scope.upVote 1, 'MediaFile'

    expect(promise.success).toHaveBeenCalled()
