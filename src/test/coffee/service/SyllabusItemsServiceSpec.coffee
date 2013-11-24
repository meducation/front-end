describe 'Syllabus Items Service', () ->

  service = null
  mockHttpBackend = null
  apiServerURI = '/api'

  beforeEach () ->
    module 'meducationFrontEnd'
    inject (syllabusItemsService, _$httpBackend_) ->
      service = syllabusItemsService
      mockHttpBackend = _$httpBackend_

  it 'Should be instantiated', () ->
    expect(service).not.toBeNull()

  it 'should GET with the correct URI when fetching all items', ->
    mockHttpBackend.expectGET("#{apiServerURI}/syllabus_items").respond 200

    service.query()

    mockHttpBackend.flush()
