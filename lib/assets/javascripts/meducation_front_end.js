(function() {
  var mainModule, medContentWidgetFunction, medVoterFunction, mediaFileFormControllerFunction, mediaFileUploadControllerFunction, syllabusItemsControllerFunction, syllabusItemsServiceFunction, votesServiceFunction;

  angular.module('meducationTemplates', ['/assets/commentVote.html', '/assets/contentWidget.html', '/assets/pageVote.html', '/assets/premiumContentWidget.html']);

  angular.module("/assets/commentVote.html", []).run([
    "$templateCache", function($templateCache) {
      return $templateCache.put("/assets/commentVote.html", "<div class=\"votes comment\">\n" + "    <div class=\"rating\" data-ng-bind=\"ratingText\" data-ng-class=\"{negative: negative}\"></div>\n" + "    <button class=\"pure-button thumb_up\" data-ng-click=\"upVote()\" data-ng-class=\"{selected: votedUp}\">\n" + "        <i class=\"fa fa-thumbs-up\"></i>\n" + "    </button>\n" + "    <button class=\"pure-button fa thumb_down\" data-ng-click=\"downVote()\" data-ng-class=\"{selected: votedDown}\">\n" + "        <i class=\"fa fa-thumbs-down\"></i>\n" + "    </button>\n" + "</div>");
    }
  ]);

  angular.module("/assets/contentWidget.html", []).run([
    "$templateCache", function($templateCache) {
      return $templateCache.put("/assets/contentWidget.html", "<aside class=\"{{ parsedItem.class }} content_widget {{ parsedItem.type }}\" data-ng-switch on=\"interactive\">\n" + "    <a href=\"{{ parsedItem.url }}\" title=\"{{ parsedItem.title }}\" data-ng-switch-when=\"true\">\n" + "        <div class=\"img\" style=\"background-image:url('{{ parsedItem.img }}')\"></div>\n" + "        <h5 class=\"title\">{{ parsedItem.title.substring(0, 89) }}</h5>\n" + "        <div class=\"byline\">{{ parsedItem.author }}</div>\n" + "    </a>\n" + "    <div title=\"{{ parsedItem.title }}\" data-ng-switch-default>\n" + "        <div class=\"img\" style=\"background-image:url('{{ parsedItem.img }}')\"></div>\n" + "        <h5 class=\"title\">{{ parsedItem.title.substring(0, 89) }}</h5>\n" + "        <div class=\"byline\">{{ parsedItem.author }}</div>\n" + "    </div>\n" + "</aside>");
    }
  ]);

  angular.module("/assets/pageVote.html", []).run([
    "$templateCache", function($templateCache) {
      return $templateCache.put("/assets/pageVote.html", "<div class=\"votes\" id=\"{{elementID}}\">\n" + "    <div class=\"thumbs\">\n" + "        <div class=\"pure-g-r\">\n" + "            <div class=\"pure-u-1-2 up\">\n" + "                <button class=\"pure-button thumb_up\" data-ng-click=\"upVote()\" data-ng-class=\"{selected: votedUp}\">\n" + "                    <i class=\"fa fa-thumbs-up\"></i>\n" + "                </button>\n" + "            </div>\n" + "            <div class=\"pure-u-1-2 down\">\n" + "                <button class=\"pure-button fa thumb_down\" data-ng-click=\"downVote()\" data-ng-class=\"{selected: votedDown}\">\n" + "                    <i class=\"fa fa-thumbs-down\"></i>\n" + "                </button>\n" + "            </div>\n" + "        </div>\n" + "    </div>\n" + "    <div class=\"rating\" data-ng-bind=\"ratingText\" data-ng-class=\"{negative: negative}\"></div>\n" + "</div>\n" + "<div style=\"padding:8px;\" id=\"fe-facebook_prompt\" ng-hide=\"true\">\n" + "    <h3 style=\"margin-top:0px\">Like this on Facebook too.</h3>\n" + "    <form accept-charset=\"UTF-8\" action=\"\"\n" + "          data-remote=\"true\" id=\"publish_to_facebook_item_vote_path_form\"\n" + "          method=\"post\">\n" + "        <div style=\"margin:0;padding:0;display:inline\">\n" + "            <input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\"/>\n" + "            <input name=\"_method\" type=\"hidden\" value=\"put\"/>\n" + "            <input name=\"authenticity_token\" type=\"hidden\"\n" + "                   value=\"ywBPFkQ1SLISxEOWOl1cELZCR5dFjk9OYAO3+FWrVuU=\"/>\n" + "        </div>\n" + "        <p>Why not share this with your friends on Facebook as well?</p>\n" + "        <div ng-show=\"facebookConnected\">\n" + "            <input id=\"always\" name=\"always\" type=\"checkbox\" value=\"1\" class=\"angular\" checked />\n" + "            <label for=\"always\">Automatically like things on Facebook?</label>\n" + "            <input type=\"submit\" name=\"commit\" class=\"pure-button\" value=\"Like this on Facebook\"/>\n" + "        </div>\n" + "        <div ng-hide=\"facebookConnected\">\n" + "            <a href=\"/auth/facebook\" class=\"btn facebook_connect_btn\"\n" + ("               data-redirect-url=\"" + location.protocol + "//" + location.host + "/my/votes?item%5Bid%5D={{id}}&item%5Btype%5D={{type}}&liked=1\">Connect To Facebook</a>\n") + "        </div>\n" + "        <a class=\"no_thanks\" href=\"#\" style=\"line-height: 32px;\n" + "            vertical-align: middle;margin-left:8px;font-size:12px\">No Thanks »</a>\n" + "    </form>\n" + "</div>");
    }
  ]);

  angular.module("/assets/premiumContentWidget.html", []).run([
    "$templateCache", function($templateCache) {
      return $templateCache.put("/assets/premiumContentWidget.html", "<aside class=\" content_widget {{ parsedItem.type }}\" data-ng-switch on=\"interactive\">\n" + "    <div class=\"premium_ribbon\">Premium</div>\n" + "    <a class=\"pure-g-r\" href=\"{{ parsedItem.url }}\" title=\"{{ parsedItem.title }}\" data-ng-switch-when=\"true\">\n" + "        <div class=\"pure-u-1-3 img\" style=\"background-image:url('{{ parsedItem.img }}')\"></div>\n" + "        <div class=\"pure-u-2-3 pad-left-small\">\n" + "            <h5 class=\"title\">{{ parsedItem.title }}</h5>\n" + "            <div class=\"byline\">{{ parsedItem.author }}</div>\n" + "        </div>\n" + "    </a>\n" + "    <div class=\"pure-g-r\" href=\"{{ parsedItem.url }}\" title=\"{{ parsedItem.title }}\" data-ng-switch-default>\n" + "        <div class=\"pure-u-1-3 img\" style=\"background-image:url('{{ parsedItem.img }}')\"></div>\n" + "        <div class=\"pure-u-2-3 pad-left-small\">\n" + "            <h5 class=\"title\">{{ parsedItem.title }}</h5>\n" + "            <div class=\"byline\">{{ parsedItem.author }}</div>\n" + "        </div>\n" + "    </div>\n" + "</aside>");
    }
  ]);

  angular.module('meducationFrontEnd', ['meducationTemplates', 'ngResource', 'blueimp.fileupload']).constant('apiURI', '/api');

  mainModule = angular.module('meducationFrontEnd');

  mediaFileFormControllerFunction = function($rootScope, $scope) {
    var unbind;
    $scope.isFormSubmissionDisabled = true;
    unbind = $rootScope.$on('originalfileurlchange', function(event, url) {
      $scope.originalFileUrl = url;
      return $scope.isFormSubmissionDisabled = false;
    });
    return $scope.$on('destroy', unbind);
  };

  mediaFileFormControllerFunction.$inject = ['$rootScope', '$scope'];

  mainModule.controller('mediaFileFormController', mediaFileFormControllerFunction);

  mainModule = angular.module('meducationFrontEnd');

  mediaFileUploadControllerFunction = function($rootScope, $scope, $element) {
    $scope.statusOKDisplay = 'none';
    $scope.statusFailDisplay = 'none';
    $scope.options = {
      dataType: null,
      autoUpload: true
    };
    $scope.$on('fileuploadprogressall', function(event, data) {
      return $scope.progressWidth = parseInt(data.loaded / data.total * 100, 10);
    });
    $scope.$on('fileuploadadd', function(event, data) {
      var ext, filename, nameParts;
      nameParts = data.files[0].name.split('.');
      ext = nameParts[nameParts.length - 1];
      filename = "original." + ext;
      $scope.s3_key = "" + ($element.data('url-root')) + filename;
      return $scope.fileName = filename;
    });
    $scope.$on('fileuploaddone', function(event, data) {
      $rootScope.$emit('originalfileurlchange', "" + data.url + $scope.s3_key);
      $scope.progressWidth = 0;
      return $scope.statusOKDisplay = 'inline';
    });
    return $scope.$on('fileuploadfail', function(event, data) {
      $scope.uploadError = data.textStatus;
      return $scope.statusFailDisplay = 'inline';
    });
  };

  mediaFileUploadControllerFunction.$inject = ['$rootScope', '$scope', '$element'];

  mainModule.controller('mediaFileUploadController', mediaFileUploadControllerFunction);

  mainModule = angular.module('meducationFrontEnd');

  syllabusItemsControllerFunction = function($scope, syllabusItemsService) {
    $scope.init = function() {
      return $scope.items = syllabusItemsService.query();
    };
    $scope.showSelect = function(level) {
      var _ref;
      return (level != null ? (_ref = level.children) != null ? _ref.length : void 0 : void 0) > 0;
    };
    return $scope.updateMeshHeadingIds = function() {
      var level, _ref;
      $scope.meshHeadingIds = [];
      level = 0;
      while ((_ref = $scope["selected" + level]) != null ? _ref.id : void 0) {
        $scope.meshHeadingIds.push($scope["selected" + level].id);
        level += 1;
      }
      return $scope.meshHeadingIds = $scope.meshHeadingIds.join(',');
    };
  };

  syllabusItemsControllerFunction.$inject = ['$scope', 'syllabusItemsService'];

  mainModule.controller('syllabusItemsController', syllabusItemsControllerFunction);

  mainModule = angular.module('meducationFrontEnd');

  medContentWidgetFunction = function($compile, $templateCache) {
    var loadTemplateFromCacheAndCompile;
    loadTemplateFromCacheAndCompile = function(element, template, scope) {
      element.html($templateCache.get(template));
      return $compile(element.contents())(scope);
    };
    return {
      restrict: 'A',
      replace: true,
      scope: {
        item: '@medContentWidget',
        interactive: '@medContentInteractive'
      },
      link: function(scope, element) {
        var template;
        scope.parsedItem = scope.$eval(scope.item);
        template = '/assets/contentWidget.html';
        if (scope.parsedItem.type === 'premium_tutorial') {
          template = '/assets/premiumContentWidget.html';
        }
        return loadTemplateFromCacheAndCompile(element, template, scope);
      }
    };
  };

  medContentWidgetFunction.$inject = ['$compile', '$templateCache'];

  mainModule.directive('medContentWidget', medContentWidgetFunction);

  mainModule = angular.module('meducationFrontEnd');

  medVoterFunction = function($compile, $templateCache) {
    var determineElementIDToUse, determineNegativeClass, determineTemplateToUse, loadTemplateFromCacheAndCompile, setRating, setVotedState;
    determineElementIDToUse = function(scope) {
      if (scope.type !== 'KnowledgeBank::Answer') {
        return scope.elementID = 'page_votes';
      }
    };
    determineTemplateToUse = function(defaultTemplate, scope) {
      var template;
      template = defaultTemplate;
      if (scope.type === 'Item::Comment') {
        template = '/assets/commentVote.html';
      } else {
        determineElementIDToUse(scope);
      }
      return template;
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
        liked: '=medVoterLiked',
        facebookConnected: '@medVoterFacebookConnected',
        facebookAutoLike: '=medVoterFacebookAutoLike'
      },
      link: function(scope, element) {
        var defaultTemplate, template;
        defaultTemplate = '/assets/pageVote.html';
        template = determineTemplateToUse(defaultTemplate, scope);
        loadTemplateFromCacheAndCompile(element, template, scope);
        setRating(scope);
        setVotedState(scope);
        return determineNegativeClass(scope, scope.rating);
      },
      controller: [
        '$scope', '$element', 'votesService', function($scope, $element, votesService) {
          var animateVoteButton, overlay, ratingValue, setRatingText, showFacebookOverlay, trackVoteAction;
          ratingValue = $scope.rating;
          overlay = function(voteID) {
            var $facebookPrompt;
            $facebookPrompt = $element.find('#fe-facebook_prompt');
            $facebookPrompt.find('form').attr('action', "/my/votes/" + voteID + "/publish_to_facebook");
            return $facebookPrompt.html();
          };
          animateVoteButton = function(direction) {
            var thumbImage;
            thumbImage = $element.find(".thumb_" + direction).children('i');
            return Meducation.UI.wiggle(thumbImage);
          };
          showFacebookOverlay = function(voteID) {
            Meducation.showAlert(overlay(voteID), 20000);
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
            promise.success(function(data) {
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
                if ($scope.type !== 'Item::Comment' && !$scope.facebookAutoLike) {
                  showFacebookOverlay(data.vote.id);
                }
              }
              setRatingText();
              determineNegativeClass($scope, ratingValue);
              return trackVoteAction(true, $scope.type);
            });
            return promise.error(function(reason, statusCode) {
              if (statusCode === 403) {
                return Meducation.showAlert("Sorry, you need to login or signup to vote. Do it - it's free!");
              }
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
            promise.success(function() {
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
            return promise.error(function(reason, statusCode) {
              if (statusCode === 403) {
                return Meducation.showAlert("Sorry, you need to login or signup to vote. Do it - it's free!");
              }
            });
          };
        }
      ]
    };
  };

  medVoterFunction.$inject = ['$compile', '$templateCache'];

  mainModule.directive('medVoter', medVoterFunction);

  mainModule = angular.module('meducationFrontEnd');

  syllabusItemsServiceFunction = function($resource, apiURI) {
    return $resource("" + apiURI + "/syllabus_items/:itemId");
  };

  syllabusItemsServiceFunction.$inject = ['$resource', 'apiURI'];

  mainModule.factory('syllabusItemsService', syllabusItemsServiceFunction);

  mainModule = angular.module('meducationFrontEnd');

  votesServiceFunction = function($http, apiURI) {
    return {
      post: function(vote) {
        var liked, params;
        liked = vote.liked ? 1 : 0;
        params = {
          'vote[item_id]': vote.item_id,
          'vote[item_type]': vote.item_type,
          'vote[liked]': liked
        };
        return $http.post("" + apiURI + "/votes", {}, {
          params: params
        });
      },
      put: function(vote) {
        var liked, params;
        liked = vote.liked ? 1 : 0;
        params = {
          'vote[liked]': liked
        };
        return $http.put("" + apiURI + "/votes/" + vote.vote_id, {}, {
          params: params
        });
      },
      "delete": function(vote) {
        return $http["delete"]("" + apiURI + "/votes/" + vote.vote_id);
      }
    };
  };

  votesServiceFunction.$inject = ['$http', 'apiURI'];

  mainModule.factory('votesService', votesServiceFunction);

}).call(this);

/*
//@ sourceMappingURL=meducation_front_end.js.map
*/