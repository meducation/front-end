module.exports = (grunt) ->
  grunt.initConfig

    bowerful:
      src:
        packages:
          "angular": "",
          "angular-resource": ""
        store: "lib"
      test:
        packages:
          "angular-mocks": ""
        store: "test/lib"

    connect:
      server:
        options:
          base: "."

    coffeelint:
      files: ["src/coffee/**/*.coffee", "test/coffee/**/*.coffee"]
      gruntfile: ["Gruntfile.coffee"]

    watch:
      coffee:
        options:
          livereload: true
        files: [],
        tasks: ["cofeelint:files"]

    clean:
      files: ["app/js"]

    coffee:
      src:
        options:
          sourceMap: true
        expand: true,
        flatten: true,
        cwd: "src/coffee",
        src: ["**/*.coffee"],
        dest: "app/js",
        ext: ".js"
      test:
        options:
          sourceMap: true
        expand: true,
        flatten: true,
        cwd: "test/coffee",
        src: ["**/*.coffee"],
        dest: "test/js",
        ext: ".js"

    jasmine:
      test:
        src: "app/js/*.js",
        options:
          specs: "test/js/*Spec.js",
          helpers: [
            "test/lib/angular-mocks/angular-mocks.js"
          ],
          vendor: [
            "test/lib/angular/angular.js"
          ],
          keepRunner: true
      coverage:
        src: "app/js/*.js",
        options:
          specs: "test/js/*Spec.js",
          helpers: [
            "test/lib/angular-mocks/angular-mocks.js"
          ]
          vendor: [
            "test/lib/angular/angular.js"
          ],
          template: require("grunt-template-jasmine-istanbul"),
          templateOptions:
            coverage: "tmp/coverage/coverage.json",
            report:
              type: "lcov",
              options:
                dir: "tmp/coverage"
            thresholds:
              lines: 80,
              statements: 80,
              branches: 80,
              functions: 80

  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  grunt.registerTask "server", "Start a web server to host the app.",
    ["connect", "watch"]

  grunt.registerTask "test", "Run Jasmine tests",
    ["coffee", "jasmine:test"]

  grunt.registerTask "default", "Run for first time setup.",
    ["clean", "bowerful", "coffeelint"]