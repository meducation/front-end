mainModule = angular.module 'meducationFrontEnd'

medContentWidgetFunction = ($compile, $templateCache) ->

  loadTemplateFromCacheAndCompile = (element, template, scope) ->
    element.html $templateCache.get template
    $compile(element.contents())(scope)

  {
    restrict: 'A'
    replace: true
    scope:
      item: '@medContentWidget'
      interactive: '@medContentInteractive'

    link: (scope, element) ->
      scope.parsedItem = scope.$eval(scope.item)
      template = '/assets/contentWidget.html'

      if scope.parsedItem.type is 'premium_tutorial'
        template = '/assets/premiumContentWidget.html'

      loadTemplateFromCacheAndCompile element, template, scope
  }

medContentWidgetFunction.$inject = ['$compile', '$templateCache']
mainModule.directive 'medContentWidget', medContentWidgetFunction