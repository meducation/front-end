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

    express:
      dev:
        options:
          cmd: "coffee"
          script: "src/app/server.coffee"

    coffeelint:
      files: [
        "src/app/**/*.coffee"
        "src/coffee/**/*.coffee"
        "src/test/coffee/**/*.coffee"
      ]
      gruntfile: ["Gruntfile.coffee"]

    watch:
      coffee:
        options:
          livereload: true
          nospawn: true
        files: [
          "src/coffee/**/*.coffee"
          "src/test/coffee/**/*.coffee"
        ]
        tasks: [
          "express:dev"
          "coffeelint:files"
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
        src: [
          "lib/assets/javascripts/meducation_front_end.js"
          "lib/assets/javascripts/*.js"
        ]
        options:
          specs: "tmp/test/js/*Spec.js"
          helpers: [
            "src/test/lib/angular-mocks/angular-mocks.js"
          ]
          vendor: [
            "src/test/lib/angular/angular.js"
            "src/test/lib/angular-resource/angular-resource.js"
          ]
          keepRunner: true
      coverage:
        src: [
          "lib/assets/javascripts/meducation_front_end.js"
          "lib/assets/javascripts/*.js"
        ]
        options:
          specs: "tmp/test/js/*Spec.js"
          helpers: [
            "src/test/lib/angular-mocks/angular-mocks.js"
          ]
          vendor: [
            "src/test/lib/angular/angular.js"
            "src/test/lib/angular-resource/angular-resource.js"
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

  require("matchdep").filterDev("grunt-!(template)*").forEach grunt.loadNpmTasks

  grunt.registerTask "server", "Start a web server to host the app.",
    ["express:dev", "watch"]

  grunt.registerTask "test-with-coverage", "Run Jasmine tests with coverage",
    ["coffee", "jasmine:coverage"]

  grunt.registerTask "test", "Run Jasmine tests",
    ["coffee", "jasmine:test"]

  grunt.registerTask "default", "Run for first time setup.",
    ["clean", "bowerful", "coffeelint", "test-with-coverage"]