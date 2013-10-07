(function() {
  var mainModule;

  mainModule = angular.module("meducationFrontEnd");

  mainModule.factory("votesService", function($http) {
    return {
      post: function(vote) {
        var liked, params;
        liked = vote.liked ? 1 : 0;
        params = "vote[item_id]=" + vote.item_id + "      &vote[item_type]=" + vote.item_type + "&liked=" + liked;
        return $http.post("/votes", encodeURI(params.replace(/\ /g, '')));
      },
      put: function(vote) {
        var liked, params;
        liked = vote.liked ? 1 : 0;
        params = "vote[liked]=" + liked;
        return $http.put("/votes/" + vote.vote_id, encodeURI(params));
      },
      "delete": function(vote) {
        return $http["delete"]("/votes/" + vote.vote_id);
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=VotesService.js.map
*/