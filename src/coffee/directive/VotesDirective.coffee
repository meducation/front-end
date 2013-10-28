mainModule = angular.module 'meducationFrontEnd'

medVoterFunction = ($compile, $templateCache) ->

  determineElementIDToUse = (scope) ->
    scope.elementID = 'page_votes' unless scope.type is 'KnowledgeBank::Answer'

  determineTemplateToUse = (defaultTemplate, scope) ->
    template = defaultTemplate
    if scope.type is 'Item::Comment' or scope.type is 'Premium::Tutorial'
      template = '/assets/commentVote.html'
    else
      determineElementIDToUse scope
    template

  determineFixedPositioning = (template, aDefaultTemplate, scope) ->
    if template is aDefaultTemplate and
    scope.type isnt 'KnowledgeBank::Question' and
    scope.type isnt 'KnowledgeBank::Answer'
      scope.fixed = true

  loadTemplateFromCacheAndCompile = (element, template, scope) ->
    element.html $templateCache.get(template)
    $compile(element.contents())(scope)

  determineNegativeClass = (scope, rating) ->
    scope.negative = rating < 0

  setRating = (scope) ->
    scope.ratingText = if scope.rating >= 0 then "+#{scope.rating}"
    else "#{scope.rating}"

  setVotedState = (scope) ->
    scope.votedUp = scope.liked
    scope.votedDown = if scope.liked? then !scope.liked

  {
  restrict: 'A'
  replace: true
  scope:
    id: '@medVoterId'
    type: '@medVoterType'
    rating: '=medVoterRating'
    liked: '=medVoterLiked'

  link: (scope, element) ->
    defaultTemplate = '/assets/pageVote.html'
    template = determineTemplateToUse defaultTemplate, scope
    loadTemplateFromCacheAndCompile element, template, scope
    determineFixedPositioning template, defaultTemplate, scope
    setRating scope
    setVotedState scope
    determineNegativeClass(scope, scope.rating)

  controller: ['$scope', '$element', 'votesService',
    ($scope, $element, votesService) ->
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
          determineNegativeClass($scope, ratingValue)
          trackVoteAction true, $scope.type

        promise.error (reason, statusCode) ->
          if statusCode is 403
            Meducation.showAlert(
              "Sorry, you need to login or signup to vote. Do it - it's free!")

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
          determineNegativeClass($scope, ratingValue)
          trackVoteAction false, $scope.type

        promise.error (reason, statusCode) ->
          if statusCode is 403
            Meducation.showAlert(
              "Sorry, you need to login or signup to vote. Do it - it's free!")
  ]
  }

medVoterFunction.$inject = ['$compile', '$templateCache']
mainModule.directive 'medVoter', medVoterFunction