mainModule = angular.module 'meducationFrontEnd'

medVoterFunction = ($compile, $templateCache) ->

  determineElementIDToUse = (scope) ->
    scope.elementID = 'page_votes' unless scope.type is 'KnowledgeBank::Answer'

  determineTemplateToUse = (defaultTemplate, scope) ->
    template = defaultTemplate
    if scope.type is 'Item::Comment'
      template = '/assets/commentVote.html'
    else
      determineElementIDToUse scope
    template

  loadTemplateFromCacheAndCompile = (element, template, scope) ->
    element.html $templateCache.get template
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
    facebookConnected: '@medVoterFacebookConnected'
    facebookAutoLike: '=medVoterFacebookAutoLike'

  link: (scope, element) ->
    defaultTemplate = '/assets/pageVote.html'
    template = determineTemplateToUse defaultTemplate, scope
    loadTemplateFromCacheAndCompile element, template, scope
    setRating scope
    setVotedState scope
    determineNegativeClass scope, scope.rating

  controller: ['$scope', '$element', 'votesService',
    ($scope, $element, votesService) ->
      ratingValue = $scope.rating

      overlay = (voteID) ->
        $facebookPrompt = $element.find '#fe-facebook_prompt'
        $facebookPrompt.find('form').attr 'action',
          "/my/votes/#{voteID}/publish_to_facebook"
        $facebookPrompt.html()

      # TODO: Move to directive
      animateVoteButton = (direction) ->
        thumbImage = $element.find(".thumb_#{direction}").children 'i'
        Meducation.UI.wiggle thumbImage

      # TODO: Move to controller
      showFacebookOverlay = (voteID) ->
        Meducation.showAlert overlay(voteID), 20000
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

            if $scope.type isnt 'Item::Comment' and not $scope.facebookAutoLike
              showFacebookOverlay(data.vote.id)

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