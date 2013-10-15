(function() {
  var mainModule;

  angular.module("meducationFrontEnd", []).constant('apiScheme', 'http').constant('apiHostname', 'localhost').constant('apiPort', 8000);

  mainModule = angular.module('meducationFrontEnd');

  mainModule.controller('votesController', function($scope, votesService) {
    var animateVoteButton, overlay, ratingValue, setRatingText, showFacebookOverlay, trackVoteAction;
    ratingValue = $('#page_votes').data('rating');
    $scope.ratingText = "+" + ratingValue;
    overlay = "<div style=\"padding:8px;\">\n  <h3 style=\"margin-top:0px\">Like this on Facebook too.</h3>\n  <form accept-charset=\"UTF-8\" action=\"/my/votes/13176/publish_to_facebook\"\n    data-remote=\"true\" id=\"publish_to_facebook_item_vote_path_form\"\n    method=\"post\">\n    <div style=\"margin:0;padding:0;display:inline\">\n      <input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\"/>\n      <input name=\"_method\" type=\"hidden\" value=\"put\"/>\n      <input name=\"authenticity_token\" type=\"hidden\"\n        value=\"ywBPFkQ1SLISxEOWOl1cELZCR5dFjk9OYAO3+FWrVuU=\"/>\n    </div>\n    <p>Why not share this with your friends on Facebook as well?</p>\n    <a href=\"/auth/facebook\" class=\"btn facebook_connect_btn\"\n      data-redirect-url=\"http://localhost:3000/my/votes?item%5Bid%5D=29973\n        &amp;item%5Btype%5D=MediaFile&amp;liked=1\">Connect To Facebook</a>\n    <a class=\"no_thanks\" href=\"#\" style=\"line-height: 32px;\n      vertical-align: middle;margin-left:8px;font-size:12px\">No Thanks »</a>\n  </form>\n</div>";
    animateVoteButton = function(direction) {
      return Meducation.UI.wiggle($(".thumb_" + direction).children('img'));
    };
    showFacebookOverlay = function() {
      Meducation.showAlert(overlay, 20000);
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
    $scope.upVote = function(itemId, itemType) {
      var promise;
      promise = votesService.post({
        item_id: itemId,
        item_type: itemType,
        liked: true
      });
      return promise.success(function() {
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
          animateVoteButton('up');
          showFacebookOverlay();
        }
        setRatingText();
        return trackVoteAction(true, itemType);
      });
    };
    return $scope.downVote = function(itemId, itemType) {
      var promise;
      promise = votesService.post({
        item_id: itemId,
        item_type: itemType,
        liked: false
      });
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
          animateVoteButton('down');
        }
        setRatingText();
        return trackVoteAction(false, itemType);
      });
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