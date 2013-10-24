angular.module('meducationTemplates', ['/assets/commentVote.html', '/assets/pageVote.html'])

angular.module("/assets/commentVote.html", []).run(["$templateCache", ($templateCache) ->
  $templateCache.put("/assets/commentVote.html",
    "<div class=\"votes\" data-ng-class=\"{negative: negative}\">\n" +
    "    <!-- TODO: remove inline styling -->\n" +
    "    <button style=\"float: left; border: none; margin-top: 4px; padding: 0; background-color: white; outline: none;\"\n" +
    "            data-ng-click=\"upVote()\" class=\"thumb_up\" data-ng-class=\"{selected: votedUp}\" rel=\"nofollow\"\n" +
    "        title=\"Vote up\">\n" +
    "        <img alt=\"\" src=\"https://d20aydchnypyzp.cloudfront.net/assets/i/thumb_up-bb41b1702e5bde05750f0eaf8dcc5855.png\">\n" +
    "    </button>\n" +
    "    <div class=\"or\">or</div>\n" +
    "    <button style=\"float: left; border: none; margin-top: 4px; padding: 0; background-color: white; outline: none;\"\n" +
    "            data-ng-click=\"downVote()\" class=\"thumb_down\" data-ng-class=\"{selected: votedDown}\" rel=\"nofollow\"\n" +
    "       title=\"Vote down\">\n" +
    "        <img alt=\"\" src=\"https://d20aydchnypyzp.cloudfront.net/assets/i/thumb_down-589c9f572e47e14cd7788ea94b333289.png\">\n" +
    "    </button>\n" +
    "    <div class=\"rating\" data-ng-bind=\"ratingText\"></div>\n" +
    "</div>")
])

angular.module("/assets/pageVote.html", []).run(["$templateCache", ($templateCache) ->
  $templateCache.put("/assets/pageVote.html",
    "<div class=\"votes\" id=\"page_votes\" data-ng-class=\"{fix_position_on_scroll: fixed, negative: negative}\">\n" +
    "    <!-- TODO: remove inline styling -->\n" +
    "    <button style=\"border: none; padding: 0; background-color: white; outline: none;\"\n" +
    "            data-ng-click=\"upVote()\" class=\"thumb_up\" data-ng-class=\"{selected: votedUp}\"\n" +
    "       rel=\"nofollow\" title=\"Vote up\">\n" +
    "        <img alt=\"\" src=\"https://d20aydchnypyzp.cloudfront.net/assets/i/thumb_up-bb41b1702e5bde05750f0eaf8dcc5855.png\">\n" +
    "    </button>\n" +
    "    <div class=\"rating\" data-ng-bind=\"ratingText\"></div>\n" +
    "    <button style=\"border: none; padding: 0; background-color: white; outline: none;\"\n" +
    "            data-ng-click=\"downVote()\" class=\"thumb_down\" data-ng-class=\"{selected: votedDown}\"\n" +
    "       rel=\"nofollow\" title=\"Vote down\">\n" +
    "        <img alt=\"\" src=\"https://d20aydchnypyzp.cloudfront.net/assets/i/thumb_down-589c9f572e47e14cd7788ea94b333289.png\">\n" +
    "    </button>\n" +
    "</div>\n" +
    "")
])

# The application starting point,
# add module dependencies to the array as required.
angular.module('meducationFrontEnd', ['meducationTemplates'])
  .constant('apiScheme', 'http')
  .constant('apiHostname', 'localhost')
  .constant('apiPort', 8000)


mainModule = angular.module 'meducationFrontEnd'

mainModule.directive 'medVoter', ($compile, $templateCache) ->

  determineTemplateToUse = (defaultTemplate, scope) ->
    template = defaultTemplate
    if scope.type is 'Item::Comment' or scope.type is 'Premium::Tutorial'
      template = '/assets/commentVote.html'
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
          determineNegativeClass($scope, ratingValue)
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
          determineNegativeClass($scope, ratingValue)
          trackVoteAction false, $scope.type
  }

mainModule = angular.module 'meducationFrontEnd'

mainModule.factory 'votesService', ($http, apiScheme, apiHostname, apiPort) ->
  uri = "#{apiScheme}://#{apiHostname}:#{apiPort}"
  {
    post: (vote) ->
      liked = if vote.liked then 1 else 0
      params = {
        'vote[item_id]': vote.item_id
        'vote[item_type]': vote.item_type
        'vote[liked]': liked
      }
      $http.post "#{uri}/votes", {}, { params: params }

    put: (vote) ->
      liked = if vote.liked then 1 else 0
      params = {
        'vote[liked]': liked
      }
      $http.put "#{uri}/votes/#{vote.vote_id}", {}, { params: params }

    delete: (vote) ->
      $http.delete "#{uri}/votes/#{vote.vote_id}"
  }
