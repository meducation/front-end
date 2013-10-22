module.exports = (grunt) ->

  srcFiles = [
    "tmp/js/MeducationFrontEnd.js"
    "tmp/js/*.js"
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
      test:
        packages:
          "jquery": "1.7.2"
          "sinonjs": ""
          "angular-mocks": ""
          "angular-resource": ""
        store: "src/test/lib"

    express:
      dev:
        options:
          cmd: "coffee"
          script: "src/app/server.coffee"
          port: 8000

    coffeelint:
      options:
        max_line_length:
          "level": "ignore"
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
      production:
        options:
          sourceMap: true
        files:
          "lib/assets/javascripts/meducation_front_end.js": [
            "src/coffee/MeducationFrontEnd.coffee"
            "src/coffee/**/*.coffee"
          ]
      src:
        options:
          sourceMap: true
        expand: true,
        flatten: true,
        cwd: "src/coffee"
        src: ["**/*.coffee"]
        dest: "tmp/js"
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

    html2js:
      options:
        module: 'meducationTemplates'
        base: 'lib/assets'
      main:
        src: ['lib/assets/templates/*.html']
        dest: 'tmp/js/Templates.js'

  require("matchdep").filterDev("grunt-!(template)*").forEach grunt.loadNpmTasks

  grunt.registerTask "server", "Start a web server to host the app.",
    ["express:dev", "watch"]

  grunt.registerTask "compile", "Compile CoffeeScript and template files",
    ["coffee", "html2js"]

  grunt.registerTask "test-with-coverage", "Run Jasmine tests with coverage",
    ["compile", "jasmine:coverage"]

  grunt.registerTask "test", "Run Jasmine tests",
    ["compile", "jasmine:test"]

  grunt.registerTask "default", "Run for first time setup.",
    ["clean", "bowerful", "coffeelint", "test-with-coverage",
     "coffee:production"]
