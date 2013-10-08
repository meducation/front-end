describe 'Votes Controller', ->

  controller = null
  $scope = null
  spiedVotesService = null

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($rootScope, $controller, votesService) ->
      $scope = $rootScope.$new()
      controller = $controller 'votesController', { $scope: $scope }
      spiedVotesService = votesService

      spyOn spiedVotesService, 'post'

  it 'should be defined', ->
    expect(controller).not.toBeNull()

  it 'should call the votes service to post an up-vote', ->
    $scope.upVote 1, 'MediaFile'

    expect(spiedVotesService.post).toHaveBeenCalledWith {
      item_id: 1
      item_type: 'MediaFile'
      liked: true
    }
