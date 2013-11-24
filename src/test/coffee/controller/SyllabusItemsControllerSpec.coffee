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
      expect($scope.showSelect($scope.selected0)).toBeFalsy()

    it 'should not show a select if the preceeding select has no children', ->
      $scope.selected1 = {
        "id": 3,
        "name": "Analgesia"
        "children": []
      }

      expect($scope.showSelect($scope.selected1)).toBeFalsy()

    it 'should show a select if the preceeding select has no children', ->
      $scope.selected2 = {
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

      expect($scope.showSelect($scope.selected2)).toBeTruthy()

  describe 'Populating the mesh heading identifiers hidden input field', ->
    it 'should set the value correctly for one selected topic', ->
      $scope.selected0 = {"id": 6 }

      $scope.updateMeshHeadingIds()

      expect($scope.meshHeadingIds).toBe '6'

    it 'should set the value correctly for multiple topics', ->
      $scope.selected0 = {"id": 6 }
      $scope.selected1 = {"id": 7 }
      $scope.selected2 = {"id": 8 }
      $scope.selected3 = {"id": 9 }
      $scope.selected4 = {"id": 10 }

      $scope.updateMeshHeadingIds()

      expect($scope.meshHeadingIds).toBe '6,7,8,9,10'

    it 'should handle a reverted selection', ->
      $scope.selected0 = {"id": 6 }
      $scope.selected1 = {"id": 7 }
      $scope.selected2 = { 'Select Topic' }

      $scope.updateMeshHeadingIds()

      expect($scope.meshHeadingIds).toBe '6,7'