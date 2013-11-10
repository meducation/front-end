describe 'Facebook Prompt Directive', ->

  compile = null
  rootScope = null
  directiveScope = null
  element = null

  directiveMarkup = '''<div data-med-facebook-prompt
                            data-med-facebook-prompt-itemId="1"
                            data-med-facebook-prompt-itemType="MediaFile"
                            data-med-facebook-prompt-voteId="2">'''

  setupDOM = (directiveMarkup) ->
    element = compile(directiveMarkup)(rootScope)
    rootScope.$digest()
    element.scope()

  beforeEach ->
    module 'meducationFrontEnd', 'meducationTemplates'
    inject ($compile, $rootScope) ->
      compile = $compile
      rootScope = $rootScope

    directiveScope = setupDOM directiveMarkup

  it 'should be tested', ->
    #TODO