(function() {
  var mainModule;

  mainModule = angular.module("meducationFrontEnd");

  mainModule.factory("votesService", function($http) {
    return {
      post: function(vote) {
        var liked, params;
        liked = vote.liked ? 1 : 0;
        params = "vote[item_id]=" + vote.id + "      &vote[item_type]=" + vote.type + "&liked=" + liked;
        return $http.post("/votes", encodeURI(params.replace(/\ /g, '')));
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=VotesService.js.map
*/