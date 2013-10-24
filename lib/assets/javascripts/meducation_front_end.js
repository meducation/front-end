(function() {
  var mainModule;

  angular.module('meducationTemplates', ['/assets/commentVote.html', '/assets/pageVote.html']);

  angular.module("/assets/commentVote.html", []).run([
    "$templateCache", function($templateCache) {
      return $templateCache.put("/assets/commentVote.html", "<div class=\"votes\" data-ng-class=\"{negative: negative}\">\n" + "    <!-- TODO: remove inline styling -->\n" + "    <button style=\"float: left; border: none; margin-top: 4px; padding: 0; background-color: white; outline: none;\"\n" + "            data-ng-click=\"upVote()\" class=\"thumb_up\" data-ng-class=\"{selected: votedUp}\" rel=\"nofollow\"\n" + "        title=\"Vote up\">\n" + "        <img alt=\"\" src=\"https://d20aydchnypyzp.cloudfront.net/assets/i/thumb_up-bb41b1702e5bde05750f0eaf8dcc5855.png\">\n" + "    </button>\n" + "    <div class=\"or\">or</div>\n" + "    <button style=\"float: left; border: none; margin-top: 4px; padding: 0; background-color: white; outline: none;\"\n" + "            data-ng-click=\"downVote()\" class=\"thumb_down\" data-ng-class=\"{selected: votedDown}\" rel=\"nofollow\"\n" + "       title=\"Vote down\">\n" + "        <img alt=\"\" src=\"https://d20aydchnypyzp.cloudfront.net/assets/i/thumb_down-589c9f572e47e14cd7788ea94b333289.png\">\n" + "    </button>\n" + "    <div class=\"rating\" data-ng-bind=\"ratingText\"></div>\n" + "</div>");
    }
  ]);

  angular.module("/assets/pageVote.html", []).run([
    "$templateCache", function($templateCache) {
      return $templateCache.put("/assets/pageVote.html", "<div class=\"votes\" id=\"page_votes\" data-ng-class=\"{fix_position_on_scroll: fixed, negative: negative}\">\n" + "    <!-- TODO: remove inline styling -->\n" + "    <button style=\"border: none; padding: 0; background-color: white; outline: none;\"\n" + "            data-ng-click=\"upVote()\" class=\"thumb_up\" data-ng-class=\"{selected: votedUp}\"\n" + "       rel=\"nofollow\" title=\"Vote up\">\n" + "        <img alt=\"\" src=\"https://d20aydchnypyzp.cloudfront.net/assets/i/thumb_up-bb41b1702e5bde05750f0eaf8dcc5855.png\">\n" + "    </button>\n" + "    <div class=\"rating\" data-ng-bind=\"ratingText\"></div>\n" + "    <button style=\"border: none; padding: 0; background-color: white; outline: none;\"\n" + "            data-ng-click=\"downVote()\" class=\"thumb_down\" data-ng-class=\"{selected: votedDown}\"\n" + "       rel=\"nofollow\" title=\"Vote down\">\n" + "        <img alt=\"\" src=\"https://d20aydchnypyzp.cloudfront.net/assets/i/thumb_down-589c9f572e47e14cd7788ea94b333289.png\">\n" + "    </button>\n" + "</div>\n" + "");
    }
  ]);

  angular.module('meducationFrontEnd', ['meducationTemplates']).constant('apiScheme', 'http').constant('apiHostname', 'localhost').constant('apiPort', 8000);

  mainModule = angular.module('meducationFrontEnd');

  mainModule.directive('medVoter', function($compile, $templateCache) {
    var determineFixedPositioning, determineNegativeClass, determineTemplateToUse, loadTemplateFromCacheAndCompile, setRating, setVotedState;
    determineTemplateToUse = function(defaultTemplate, scope) {
      var template;
      template = defaultTemplate;
      if (scope.type === 'Item::Comment' || scope.type === 'Premium::Tutorial') {
        template = '/assets/commentVote.html';
      }
      return template;
    };
    determineFixedPositioning = function(template, aDefaultTemplate, scope) {
      if (template === aDefaultTemplate && scope.type !== 'KnowledgeBank::Question' && scope.type !== 'KnowledgeBank::Answer') {
        return scope.fixed = true;
      }
    };
    loadTemplateFromCacheAndCompile = function(element, template, scope) {
      element.html($templateCache.get(template));
      return $compile(element.contents())(scope);
    };
    determineNegativeClass = function(scope, rating) {
      return scope.negative = rating < 0;
    };
    setRating = function(scope) {
      return scope.ratingText = scope.rating >= 0 ? "+" + scope.rating : "" + scope.rating;
    };
    setVotedState = function(scope) {
      scope.votedUp = scope.liked;
      return scope.votedDown = scope.liked != null ? !scope.liked : void 0;
    };
    return {
      restrict: 'A',
      replace: true,
      scope: {
        id: '@medVoterId',
        type: '@medVoterType',
        rating: '=medVoterRating',
        liked: '=medVoterLiked'
      },
      link: function(scope, element) {
        var defaultTemplate, template;
        defaultTemplate = '/assets/pageVote.html';
        template = determineTemplateToUse(defaultTemplate, scope);
        loadTemplateFromCacheAndCompile(element, template, scope);
        determineFixedPositioning(template, defaultTemplate, scope);
        setRating(scope);
        setVotedState(scope);
        return determineNegativeClass(scope, scope.rating);
      },
      controller: function($scope, $element, votesService) {
        var animateVoteButton, overlay, ratingValue, setRatingText, showFacebookOverlay, trackVoteAction;
        ratingValue = $scope.rating;
        overlay = function(itemID, itemType, voteID) {
          return "<div style=\"padding:8px;\">\n  <h3 style=\"margin-top:0px\">Like this on Facebook too.</h3>\n  <form accept-charset=\"UTF-8\" action=\"/my/votes/" + voteID + "/publish_to_facebook\"\n    data-remote=\"true\" id=\"publish_to_facebook_item_vote_path_form\"\n    method=\"post\">\n    <div style=\"margin:0;padding:0;display:inline\">\n      <input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\"/>\n      <input name=\"_method\" type=\"hidden\" value=\"put\"/>\n      <input name=\"authenticity_token\" type=\"hidden\"\n        value=\"ywBPFkQ1SLISxEOWOl1cELZCR5dFjk9OYAO3+FWrVuU=\"/>\n    </div>\n    <p>Why not share this with your friends on Facebook as well?</p>\n    <a href=\"/auth/facebook\" class=\"btn facebook_connect_btn\"\n      data-redirect-url=\"" + location.protocol + "//" + location.host + "/my/votes?item%5Bid%5D=" + itemID + "&item%5Btype%5D=" + itemType + "&liked=1\">Connect To Facebook</a>\n    <a class=\"no_thanks\" href=\"#\" style=\"line-height: 32px;\n      vertical-align: middle;margin-left:8px;font-size:12px\">No Thanks »</a>\n  </form>\n</div>";
        };
        animateVoteButton = function(direction) {
          var thumbImage;
          thumbImage = $element.find(".thumb_" + direction).children('img');
          return Meducation.UI.wiggle(thumbImage);
        };
        showFacebookOverlay = function(itemID, itemType, voteID) {
          Meducation.showAlert(overlay(itemID, itemType, voteID), 20000);
          $('#publish_to_facebook_item_vote_path_form .no_thanks').click(function() {
            $('.overlay.modal.alert').fadeOut();
            return false;
          });
          return $('#publish_to_facebook_item_vote_path_form').bind('submit', function() {
            Meducation.showAlert('Done!', 3000);
            return $('.overlay.modal.alert').fadeOut();
          });
        };
        trackVoteAction = function(liked, type) {
          return mixpanel.track('Action: Voted', {
            liked: liked,
            type: type
          });
        };
        setRatingText = function() {
          return $scope.ratingText = ratingValue >= 0 ? "+" + ratingValue : "" + ratingValue;
        };
        $scope.upVote = function() {
          var promise;
          promise = votesService.post({
            item_id: parseInt($scope.id, 10),
            item_type: $scope.type,
            liked: true
          });
          if (!$scope.votedUp) {
            animateVoteButton('up');
          }
          return promise.success(function(data) {
            if ($scope.votedUp) {
              ratingValue -= 1;
              $scope.votedUp = false;
            } else {
              if ($scope.votedDown) {
                ratingValue += 2;
              } else {
                ratingValue += 1;
              }
              $scope.votedUp = true;
              $scope.votedDown = false;
              showFacebookOverlay($scope.id, $scope.type, data.vote.id);
            }
            setRatingText();
            determineNegativeClass($scope, ratingValue);
            return trackVoteAction(true, $scope.type);
          });
        };
        return $scope.downVote = function() {
          var promise;
          promise = votesService.post({
            item_id: parseInt($scope.id, 10),
            item_type: $scope.type,
            liked: false
          });
          if (!$scope.votedDown) {
            animateVoteButton('down');
          }
          return promise.success(function() {
            if ($scope.votedDown) {
              ratingValue += 1;
              $scope.votedDown = false;
            } else {
              if ($scope.votedUp) {
                ratingValue -= 2;
              } else {
                ratingValue -= 1;
              }
              $scope.votedDown = true;
              $scope.votedUp = false;
            }
            setRatingText();
            determineNegativeClass($scope, ratingValue);
            return trackVoteAction(false, $scope.type);
          });
        };
      }
    };
  });

  mainModule = angular.module('meducationFrontEnd');

  mainModule.factory('votesService', function($http, apiScheme, apiHostname, apiPort) {
    var uri;
    uri = "" + apiScheme + "://" + apiHostname + ":" + apiPort;
    return {
      post: function(vote) {
        var liked, params;
        liked = vote.liked ? 1 : 0;
        params = {
          'vote[item_id]': vote.item_id,
          'vote[item_type]': vote.item_type,
          'vote[liked]': liked
        };
        return $http.post("" + uri + "/votes", {}, {
          params: params
        });
      },
      put: function(vote) {
        var liked, params;
        liked = vote.liked ? 1 : 0;
        params = {
          'vote[liked]': liked
        };
        return $http.put("" + uri + "/votes/" + vote.vote_id, {}, {
          params: params
        });
      },
      "delete": function(vote) {
        return $http["delete"]("" + uri + "/votes/" + vote.vote_id);
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=meducation_front_end.js.map
*/