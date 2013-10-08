(function() {
  var mainModule;

  mainModule = angular.module('meducationFrontEnd');

  mainModule.controller('votesController', function($scope, votesService) {
    return $scope.upVote = function(itemId, itemType) {
      return votesService.post({
        item_id: itemId,
        item_type: itemType,
        liked: true
      });
    };
  });

}).call(this);

/*
//@ sourceMappingURL=VotesController.js.map
*/