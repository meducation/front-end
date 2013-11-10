mainModule = angular.module 'meducationFrontEnd'

medFacebookPromptFunction = ($compile, $templateCache) ->

  #TODO: Move to helper service
  loadTemplateFromCacheAndCompile = (element, template, scope) ->
    element.html $templateCache.get(template)
    $compile(element.contents())(scope)

  {
    restrict: 'A'
    replace: true
    scope:
      itemId: '@medmedFacebookPromptItemId'
      itemType: '@medFacebookPromptItemType'
      voteId: '@medFacebookPromptVoteId'

    link: (scope, element) ->
      loadTemplateFromCacheAndCompile element, '/assets/facebookPrompt.html', scope
      #TODO

    controller: ['$scope', '$element', ($scope, $element) ->
      #TODO
    ]
  }

medFacebookPromptFunction.$inject = ['$compile', '$templateCache']
mainModule.directive 'medFacebookPrompt', medFacebookPromptFunction