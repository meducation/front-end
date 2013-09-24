(function() {
  var mainModule;

  mainModule = angular.module("meducationFrontEnd", ["ng"]);

  mainModule.factory("votesService", function($http) {
    return {
      post: function(vote) {
        var liked, params;
        liked = vote.liked ? 1 : 0;
        params = "item[id]=" + vote.id + "&item[type]=" + vote.type + "&liked=" + liked;
        return $http.post("/my/votes", encodeURI(params));
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=VotesService.js.map
*/