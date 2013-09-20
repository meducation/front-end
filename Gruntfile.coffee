module.exports = (grunt) ->
  grunt.initConfig

    bowerful:
      src:
        packages:
          "angular": ""
          "angular-resource": ""
        store: "vendor/assets/javascripts"
      test:
        packages:
          "angular-mocks": ""
        store: "src/test/lib"

    connect:
      server:
        options:
          base: "."

    coffeelint:
      files: [
        "src/coffee/**/*.coffee"
        "src/test/coffee/**/*.coffee"
      ]
      gruntfile: ["Gruntfile.coffee"]

    watch:
      coffee:
        options:
          livereload: true
        files: []
        tasks: [
          "cofeelint:files"
          "test"
        ]

    clean:
      files: [
        "tmp"
      ]

    coffee:
      src:
        options:
          sourceMap: true
        expand: true,
        flatten: true,
        cwd: "src/coffee"
        src: ["**/*.coffee"]
        dest: "lib/assets/javascripts"
        ext: ".js"
      test:
        options:
          sourceMap: true
        expand: true,
        flatten: true,
        cwd: "src/test/coffee"
        src: ["**/*.coffee"]
        dest: "tmp/test/js"
        ext: ".js"

    jasmine:
      test:
        src: "lib/assets/javascripts/*.js"
        options:
          specs: "tmp/test/js/*Spec.js"
          helpers: [
            "tmp/test/lib/angular-mocks/angular-mocks.js"
          ]
          vendor: [
            "tmp/test/lib/angular/angular.js"
          ]
          keepRunner: true
      coverage:
        src: "lib/assets/javascripts/*.js"
        options:
          specs: "tmp/test/js/*Spec.js"
          helpers: [
            "tmp/test/lib/angular-mocks/angular-mocks.js"
          ]
          vendor: [
            "tmp/test/lib/angular/angular.js"
          ]
          template: require("grunt-template-jasmine-istanbul")
          templateOptions:
            coverage: "tmp/coverage/coverage.json"
            report: [
              { type: "lcov", options: { dir: "tmp/coverage" } }
              { type: "text", options: {} }
            ]
            thresholds:
              lines: 80
              statements: 80
              branches: 80
              functions: 80

  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  grunt.registerTask "server", "Start a web server to host the app.",
    ["connect", "watch"]

  grunt.registerTask "test-with-coverage", "Run Jasmine tests with coverage",
    ["coffee", "jasmine:coverage"]

  grunt.registerTask "test", "Run Jasmine tests",
    ["coffee", "jasmine:test"]

  grunt.registerTask "default", "Run for first time setup.",
    ["clean", "bowerful", "coffeelint", "test-with-coverage"]