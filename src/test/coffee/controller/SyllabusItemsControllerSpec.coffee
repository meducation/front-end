describe 'Syllabus Items Controller', ->

  controller = null
  $scope = null
  mockSyllabusItemsService = null
  promise = null

  beforeEach ->
    module 'meducationFrontEnd'
    inject ($rootScope, $controller, syllabusItemsService, $q) ->
      $scope = $rootScope.$new()

      controller = $controller 'syllabusItemsController', { $scope: $scope }

      mockSyllabusItemsService = sinon.mock syllabusItemsService
      promise = $q.defer().promise

  afterEach ->
    mockSyllabusItemsService.restore()

  it 'should be defined', ->
    expect(controller).not.toBeNull()

  it 'should query the service on when the init function is called', ->
    mockSyllabusItemsService.expects('query').once()

    $scope.init()

    mockSyllabusItemsService.verify()

  it 'should assign the result of the query to the items scope variable', ->
    syllabusItems = [
      {
        "id": 1,
        "name": "Medicine"
      },
      {
        "id": 2,
        "name": "Specialties, Surgical"
      }
    ]

    mockSyllabusItemsService.expects('query').once().returns syllabusItems

    $scope.init()

    expect($scope.items).toEqual syllabusItems
    mockSyllabusItemsService.verify()
