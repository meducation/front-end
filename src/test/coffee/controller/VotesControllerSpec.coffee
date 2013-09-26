describe "Votes Controller", () ->

  controller = null
  $scope = null

  beforeEach () ->
    module "meducationFrontEnd"
    inject ($rootScope, $controller) ->
      $scope = $rootScope.$new()
      controller = $controller "votesController", { $scope: $scope }

  it "should be defined", () ->
    expect(controller).not.toBeNull()