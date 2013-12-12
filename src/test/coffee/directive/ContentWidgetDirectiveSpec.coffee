describe 'Content Widget Directive', ->

  compile = null
  rootScope = null
  directiveScope = null
  element = null

  contentWidgetDirectiveMarkup = '''
    <aside data-med-content-interactive="true"
           data-med-content-widget="{
              class: 'mf',
              type: 'image',
              url: '/media_files/1',
              title: 'Haemogluttination/Agglutination Haemogluttination/Agglutination Haemogluttination/Agglutination',
              author: 'Dr Alastair Buick',
              img: 'http://placekitten.com/159/100'
    }"/></aside>'''

  premiumContentWidgetDirectiveMarkup = '''
    <aside data-med-content-interactive="true"
           data-med-content-widget="{
              class: 'mf',
              type: 'premium_tutorial',
              url: '/media_files/2',
              title: 'The Knee - Anatomy',
              author: 'Mr Raymond Buick',
              img: 'http://placekitten.com/159/100'
    }"/></aside>'''


  nonInteractiveWidgetDirectiveMarkup = '''
    <aside data-med-content-interactive="false"
           data-med-content-widget="{
              class: 'mf',
              type: 'document',
              url: '/media_files/2',
              title: 'The Knee - Anatomy',
              author: 'Mr Raymond Buick',
              img: 'http://placekitten.com/159/100'
    }"/></aside>'''

  nonInteractivePremiumContentWidgetDirectiveMarkup = '''
    <aside data-med-content-interactive="false"
           data-med-content-widget="{
              class: 'mf',
              type: 'premium_tutorial',
              url: '/media_files/2',
              title: 'The Knee - Anatomy',
              author: 'Mr Raymond Buick',
              img: 'http://placekitten.com/159/100'
    }"/></aside>'''

  setupDOM = (directiveMarkup) ->
    element = compile(directiveMarkup)(rootScope)
    rootScope.$digest()
    element.children().scope()

  beforeEach ->

    # The meducationTemplates module contains a module for each template in
    # JS form (run 'grunt html2js' then see tmp/js/Templates.js).
    module 'meducationFrontEnd', 'meducationTemplates'
    inject ($compile, $rootScope) ->
      compile = $compile
      rootScope = $rootScope

  describe 'Initialisation', ->

    beforeEach ->
      directiveScope = setupDOM contentWidgetDirectiveMarkup

    it 'should correctly evaluate the item', ->
      expect(directiveScope.parsedItem).toEqual {
        class: 'mf'
        type: 'image'
        url: '/media_files/1'
        title: 'Haemogluttination/Agglutination Haemogluttination/Agglutination Haemogluttination/Agglutination'
        author: 'Dr Alastair Buick'
        img: 'http://placekitten.com/159/100'
      }

    it 'should truncate the title to 90 characters', ->
      expect(element.find('.title').text()).toBe 'Haemogluttination/Agglutination Haemogluttination/Agglutination Haemogluttination/Aggluti'

  describe 'Standard Content', ->

    beforeEach ->
      directiveScope = setupDOM contentWidgetDirectiveMarkup

    it 'should render the correct template', ->
      expect(element.find('.premium_ribbon').length).toBe 0

    it 'should wrap contents in an anchor', ->
      expect(element.find('a').length).toBe 1

  describe 'Premium Content', ->

    it 'should render the correct template', ->
      directiveScope = setupDOM premiumContentWidgetDirectiveMarkup

      expect(element.find('.premium_ribbon').length).toBe 1

  describe 'Non-interactive Content', ->

    it 'should wrap contents in a div', ->
      directiveScope = setupDOM nonInteractiveWidgetDirectiveMarkup

      expect(element.find('a').length).toBe 0

  describe 'Non-interactive Premium Content', ->

    it 'should wrap contents in a div', ->
      directiveScope = setupDOM nonInteractivePremiumContentWidgetDirectiveMarkup

      expect(element.find('a').length).toBe 0