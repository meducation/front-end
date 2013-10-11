module.exports = (grunt) ->

  srcFiles = [
    "lib/assets/javascripts/meducation_front_end.js"
    "lib/assets/javascripts/*.js"
  ]
  helperFiles = [
    "src/test/lib/sinonjs/sinon.js"
    "src/test/lib/angular-mocks/angular-mocks.js"
  ]
  vendorFiles = [
    "src/test/lib/jquery/jquery.js"
    "src/test/lib/angular/angular.js"
    "src/test/lib/angular-resource/angular-resource.js"
  ]

  grunt.initConfig
    bowerful:
      src:
        packages:
          "angular": ""
          "angular-resource": ""
        store: "vendor/assets/javascripts"
      test:
        packages:
          "jquery": "1.7.2"
          "sinonjs": ""
          "angular-mocks": ""
        store: "src/test/lib"

    express:
      dev:
        options:
          cmd: "coffee"
          script: "src/app/server.coffee"
          port: 8000

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
          "src/app/**/*.coffee"
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
        src: srcFiles
        options:
          specs: "tmp/test/js/*Spec.js"
          helpers: helperFiles
          vendor: vendorFiles
          keepRunner: true
      coverage:
        src: srcFiles
        options:
          specs: "tmp/test/js/*Spec.js"
          helpers: helperFiles
          vendor: vendorFiles
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