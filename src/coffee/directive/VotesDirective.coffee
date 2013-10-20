mainModule = angular.module 'meducationFrontEnd'

mainModule.directive 'medVoter', () ->
  {
    restrict: 'A'
    templateUrl: '/assets/votes.html'
    replace: true
    scope:
      id: '@medVoterId'
      type: '@medVoterType'
      rating: '=medVoterRating'
    link: (scope) ->
      scope.ratingText = if scope.rating >= 0 then "+#{scope.rating}"
      else "#{scope.rating}"
  }
