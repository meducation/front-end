describe 'Votes Directive', ->

  element = null
  html = '<div class="med-voter"></div>'

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()

      # Get a jQuery-like wrapper around the element
      element = angular.element html

      # Compile the HTML containing the directive
      compiled = $compile element

      # Run the compiled function to trigger the directive
      compiled scope

      # Simulate scope lifecyle
      scope.$digest()

  xit 'should replace the element with a template', ->
    #TODO: figure out what this should look like
