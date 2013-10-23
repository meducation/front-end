mainModule = angular.module 'meducationFrontEnd'

mainModule.directive 'medVoter', ($compile, $templateCache) ->

  checkAndApplyNegativeClass = (scope, rating) ->
    scope.negative = rating < 0

  {
    restrict: 'A'
    replace: true
    scope:
      id: '@medVoterId'
      type: '@medVoterType'
      rating: '=medVoterRating'
      liked: '=medVoterLiked'

    link: (scope, element) ->

      templateMap = {
        "MediaFile": '/assets/pageVote.html'
        "Item::Comment": '/assets/commentVote.html'
      }

      element.html($templateCache.get(templateMap[scope.type]))
      $compile(element.contents())(scope)

      scope.ratingText = if scope.rating >= 0 then "+#{scope.rating}"
      else "#{scope.rating}"

      scope.votedUp = scope.liked
      scope.votedDown = if scope.liked? then !scope.liked

      checkAndApplyNegativeClass(scope, scope.rating)

    controller: ($scope, $element, votesService) ->
      ratingValue = $scope.rating

      # TODO: Move to a template
      overlay = (itemID, itemType, voteID) ->
        """
<div style="padding:8px;">
  <h3 style="margin-top:0px">Like this on Facebook too.</h3>
  <form accept-charset="UTF-8" action="/my/votes/#{voteID}/publish_to_facebook"
    data-remote="true" id="publish_to_facebook_item_vote_path_form"
    method="post">
    <div style="margin:0;padding:0;display:inline">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <input name="_method" type="hidden" value="put"/>
      <input name="authenticity_token" type="hidden"
        value="ywBPFkQ1SLISxEOWOl1cELZCR5dFjk9OYAO3+FWrVuU="/>
    </div>
    <p>Why not share this with your friends on Facebook as well?</p>
    <a href="/auth/facebook" class="btn facebook_connect_btn"
      data-redirect-url="#{location.protocol}//#{location.host}/my/votes?item%5Bid%5D=#{itemID}&item%5Btype%5D=#{itemType}&liked=1">Connect To Facebook</a>
    <a class="no_thanks" href="#" style="line-height: 32px;
      vertical-align: middle;margin-left:8px;font-size:12px">No Thanks »</a>
  </form>
</div>
        """

      # TODO: Move to directive
      animateVoteButton = (direction) ->
        thumbImage = $element.find(".thumb_#{direction}").children 'img'
        Meducation.UI.wiggle thumbImage

      # TODO: Move to controller
      showFacebookOverlay = (itemID, itemType, voteID) ->
        Meducation.showAlert overlay(itemID, itemType, voteID), 20000
        $('#publish_to_facebook_item_vote_path_form .no_thanks').click ->
          $('.overlay.modal.alert').fadeOut()
          false
        $('#publish_to_facebook_item_vote_path_form').bind 'submit', ->
          Meducation.showAlert 'Done!', 3000
          $('.overlay.modal.alert').fadeOut()

      # TODO: Move to directive
      trackVoteAction = (liked, type) ->
        mixpanel.track 'Action: Voted', {liked: liked, type: type}

      setRatingText = ->
        $scope.ratingText = if ratingValue >= 0 then "+#{ratingValue}"
        else "#{ratingValue}"

      $scope.upVote = ->
        promise = votesService.post({
          item_id: parseInt($scope.id, 10), item_type: $scope.type, liked: true
        })

        animateVoteButton 'up' unless $scope.votedUp

        promise.success (data) ->
          if $scope.votedUp
            ratingValue -= 1
            $scope.votedUp = false
          else
            if $scope.votedDown then ratingValue +=2 else ratingValue += 1
            $scope.votedUp = true
            $scope.votedDown = false
            showFacebookOverlay($scope.id, $scope.type, data.vote.id)

          setRatingText()
          checkAndApplyNegativeClass($scope, ratingValue)
          trackVoteAction true, $scope.type

      $scope.downVote = ->
        promise = votesService.post({
          item_id: parseInt($scope.id, 10), item_type: $scope.type, liked: false
        })

        animateVoteButton 'down' unless $scope.votedDown

        promise.success ->
          if $scope.votedDown
            ratingValue += 1
            $scope.votedDown = false
          else
            if $scope.votedUp then ratingValue -=2 else ratingValue -= 1
            $scope.votedDown = true
            $scope.votedUp = false

          setRatingText()
          checkAndApplyNegativeClass($scope, ratingValue)
          trackVoteAction false, $scope.type
  }
