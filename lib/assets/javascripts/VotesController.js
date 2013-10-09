(function() {
  var mainModule;

  mainModule = angular.module('meducationFrontEnd');

  mainModule.controller('votesController', function($scope, votesService) {
    return $scope.upVote = function(itemId, itemType) {
      var promise;
      promise = votesService.post({
        item_id: itemId,
        item_type: itemType,
        liked: true
      });
      return promise.success(function() {});
    };
  });

}).call(this);

/*
//@ sourceMappingURL=VotesController.js.map
*/