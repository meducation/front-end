mainModule = angular.module 'meducationFrontEnd'

mainModule.directive 'medVoter', () ->
  {
    restrict: 'A'
    templateUrl: '/assets/votes.html'
    replace: true
  }