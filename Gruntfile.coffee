module.exports = (grunt) ->

  env = process.env
  ciJobId = if env.TRAVIS_JOB_ID then env.TRAVIS_JOB_ID else 0
  ciBuildNo = if env.TRAVIS_BUILD_NUMBER then env.TRAVIS_BUILD_NUMBER else '-1'
  ciBranch = if env.TRAVIS_BRANCH then env.TRAVIS_BRANCH else 'local'

  srcFiles = [
    'tmp/js/MeducationTemplates.js'
    'tmp/js/MeducationFrontEnd.js'
    'tmp/js/*.js'
  ]
  helperFiles = [
    'src/test/lib/sinonjs/sinon.js'
    'src/test/lib/angular-mocks/angular-mocks.js'
  ]
  vendorFiles = [
    'src/test/lib/jquery/jquery.js'
    'src/test/lib/angular/angular.js'
    'src/test/lib/angular-resource/angular-resource.js'
    'vendor/assets/javascripts/jquery.fileupload-angular.js'
  ]

  grunt.initConfig
    bowerful:
      test:
        packages:
          'jquery': '1.7.2'
          'blueimp-file-upload': '9.4.1'
          'sinonjs': ''
          'angular-mocks': '1.2.0'
          'angular-resource': '1.2.0'
        store: 'src/test/lib'

    express:
      dev:
        options:
          cmd: 'coffee'
          script: 'src/app/server.coffee'
          port: 5000

    coffeelint:
      options:
        max_line_length:
          'level': 'ignore'
      files: [
        'src/app/**/*.coffee'
        'src/coffee/**/*.coffee'
        'src/test/coffee/**/*.coffee'
      ]
      gruntfile: ['Gruntfile.coffee']

    watch:
      options:
        livereload: true
        nospawn: true
      coffee:
        files: [
          'src/app/**/*.coffee'
          'src/coffee/**/*.coffee'
          'src/test/coffee/**/*.coffee'
        ]
        tasks: [
          'express:dev'
          'default'
        ]
      templates:
        files: ['lib/assets/templates/**/*.html']
        tasks: ['default']
      sass:
        files: ['src/scss/**/*.scss']
        tasks: ['default']

    clean:
      files: [
        'tmp'
      ]

    coffee:
      production:
        options:
          sourceMap: true
        files:
          'lib/assets/javascripts/meducation_front_end.js': [
            'tmp/coffee/MeducationTemplates.coffee'
            'src/coffee/MeducationFrontEnd.coffee'
            'src/coffee/**/*.coffee'
          ]
      src:
        options:
          sourceMap: true
        expand: true,
        flatten: true,
        cwd: 'src/coffee'
        src: ['**/*.coffee']
        dest: 'tmp/js'
        ext: '.js'
      test:
        options:
          sourceMap: true
        expand: true,
        flatten: true,
        cwd: 'src/test/coffee'
        src: ['**/*.coffee']
        dest: 'tmp/test/js'
        ext: '.js'

    sass:
      dist:
        files:
          'lib/assets/stylesheets/meducation_front_end.css': 'src/scss/meducation_front_end.scss'

    uglify:
      production:
        files:
          'lib/assets/javascripts/meducation_front_end.min.js':
            ['lib/assets/javascripts/meducation_front_end.js']

    csslint:
      options:
        csslintrc: '.csslintrc'
      lint:
        src: ['lib/assets/stylesheets/**/*.css']

    jasmine:
      test:
        src: srcFiles
        options:
          specs: 'tmp/test/js/*Spec.js'
          helpers: helperFiles
          vendor: vendorFiles
          keepRunner: true
      coverage:
        src: srcFiles
        options:
          specs: 'tmp/test/js/*Spec.js'
          helpers: helperFiles
          vendor: vendorFiles
          keepRunner: true
          template: require('grunt-template-jasmine-istanbul')
          templateOptions:
            coverage: 'tmp/coverage/coverage.json'
            report: [
              { type: 'lcov', options: { dir: 'tmp/coverage' } }
              { type: 'text', options: {} }
            ]
            thresholds:
              lines: 80
              statements: 80
              branches: 80
              functions: 80

    connect:
      server:
        options: {}

    'saucelabs-jasmine':
      test:
        options:
          username: 'meducation'
          urls: ['http://127.0.0.1:8000/_SpecRunner.html']
          concurrency: 3
          testname: 'Meducation front-end tests'
          build: ciJobId
          tags: [ciBuildNo, ciBranch]
          testTimeout: 60000
          tunnelTimeout: 60000
          detailedError: true
          browsers: [{
            browserName: 'internet explorer',
            version: '11',
            platform: 'Windows 8.1'
          }, {
            browserName: 'internet explorer',
            version: '10',
            platform: 'Windows 8'
          }, {
            browserName: 'internet explorer',
            version: '9',
            platform: 'Windows 7'
#          }, {
#            browserName: 'internet explorer',
#            version: '8',
#            platform: 'Windows 7'
          }, {
            browserName: 'chrome',
            platform: 'Linux',
            version: '30'
          }, {
            browserName: 'firefox',
            platform: 'Linux',
            version: '25'
          }, {
            browserName: 'safari',
            platform: 'OS X 10.8',
            version: '6'
          }, {
            browserName: 'opera',
            version: '12',
            platform: 'Linux'
          }]

    html2js:
      options:
        module: 'meducationTemplates'
        base: 'lib/assets'
        # Creates template cache keys which are the URLs the rails asset
        # pipeline expects i.e.: /assets/templateName.html
        rename: (moduleName) ->
          moduleName.replace('templates', '/assets')
      js:
        src: ['lib/assets/templates/*.html']
        dest: 'tmp/js/MeducationTemplates.js'
      coffee:
        options:
          target: 'coffee'
        src: ['lib/assets/templates/*.html']
        dest: 'tmp/coffee/MeducationTemplates.coffee'

  require('matchdep').filterDev('grunt-!(template)*').forEach grunt.loadNpmTasks

  grunt.registerTask 'server', 'Start a web server to host the app.',
    ['express:dev', 'watch']

  grunt.registerTask 'compile', 'Compile CoffeeScript and template files',
    ['coffee', 'html2js']

  grunt.registerTask 'test-with-coverage', 'Run Jasmine tests with coverage',
    ['compile', 'jasmine:coverage']

  grunt.registerTask 'test', 'Run Jasmine tests',
    ['compile', 'jasmine:test']

  grunt.registerTask 'saucelabs', 'Run tests in real browsers via Saucelabs',
    ['connect', 'test', 'saucelabs-jasmine']

  grunt.registerTask 'default', 'Run for first time setup.',
    ['clean', 'bowerful', 'csslint', 'coffeelint', 'test-with-coverage',
     'sass', 'coffee:production', 'uglify']
