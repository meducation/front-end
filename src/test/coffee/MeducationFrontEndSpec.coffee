describe "Meducation Front-end Application Module", () ->
  it "should be available as a module", () ->
    frontEndApplicationModule = angular.module "meducationFrontEnd"
    expect(frontEndApplicationModule.name).toBe "meducationFrontEnd"