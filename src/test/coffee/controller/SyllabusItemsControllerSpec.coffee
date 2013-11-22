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

  describe 'Querying the service', ->
    it 'should query the service on when the init function is called', ->
      mockSyllabusItemsService.expects('query').once()

      $scope.init()

      mockSyllabusItemsService.verify()

    it 'should assign the result of the query to the items scope variable', ->
      syllabusItems = [
        {
          "id": 1,
          "name": "Medicine",
          "children": []
        },
        {
          "id": 2,
          "name": "Specialties, Surgical",
          "children": []
        }
      ]

      mockSyllabusItemsService.expects('query').once().returns syllabusItems

      $scope.init()

      expect($scope.items).toEqual syllabusItems
      mockSyllabusItemsService.verify()

  describe 'showing select elements', ->
    it 'should not show a select if the preceeding select not been chosen', ->
      expect($scope.showSelect($scope.selectLevel0)).toBeFalsy()

    it 'should not show a select if the preceeding select has no children', ->
      $scope.selectLevel1 = {
        "id": 3,
        "name": "Analgesia"
        "children": []
      }

      expect($scope.showSelect($scope.selectLevel1)).toBeFalsy()

    it 'should show a select if the preceeding select has no children', ->
      $scope.selectLevel2 = {
        "id": 4,
        "name": "Cardiovascular Diseases"
        "children": [
          {
            "id": 5,
            "name": "Angina Pectoris"
            "children": []
          }
        ]
      }

      expect($scope.showSelect($scope.selectLevel2)).toBeTruthy()