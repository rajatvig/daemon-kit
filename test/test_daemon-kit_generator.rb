require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestDaemonKitGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper
  
  attr_reader :daemon_name
  def setup
    bare_setup
    @daemon_name = File.basename(File.expand_path(APP_ROOT))
  end

  def teardown
    bare_teardown
  end

  # Some generator-related assertions:
  #   assert_generated_file(name, &block) # block passed the file contents
  #   assert_directory_exists(name)
  #   assert_generated_class(name, &block)
  #   assert_generated_module(name, &block)
  #   assert_generated_test_for(name, &block)
  # The assert_generated_(class|module|test_for) &block is passed the body of the class/module within the file
  #   assert_has_method(body, *methods) # check that the body has a list of methods (methods with parentheses not supported yet)
  #
  # Other helper methods are:
  #   app_root_files - put this in teardown to show files generated by the test method (e.g. p app_root_files)
  #   bare_setup - place this in setup method to create the APP_ROOT folder for each test
  #   bare_teardown - place this in teardown method to destroy the TMP_ROOT or APP_ROOT folder after each test

  def test_generator_without_options
    run_generator('daemon_kit', [APP_ROOT], sources)

    assert_generated_file   "README"
    assert_generated_file   "Rakefile"
    assert_directory_exists "bin"
    assert_generated_file   "bin/#{daemon_name}"
    assert_directory_exists "config"
    assert_generated_file   "config/boot.rb"
    assert_generated_file   "config/environment.rb"
    assert_generated_file   "config/environments/development.rb"
    assert_generated_file   "config/environments/test.rb"
    assert_generated_file   "config/environments/production.rb"
    assert_directory_exists "config/initializers"
    assert_generated_file   "config/initializers/readme"
    assert_directory_exists "lib"
    assert_generated_file   "lib/#{daemon_name}.rb"
    assert_directory_exists "libexec"
    assert_generated_file   "libexec/#{daemon_name}-daemon.rb"
    assert_directory_exists "log"
    assert_directory_exists "spec"
    assert_directory_exists "tasks"
    assert_directory_exists "vendor"
    assert_directory_exists "tmp"
  end

  private
  def sources
    [
     RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", generator_path)),
     RubiGen::PathSource.new(:app, File.join(File.dirname(__FILE__), "..", "daemon_generators")),
     RubiGen::PathSource.new(:app, File.join(File.dirname(__FILE__), "..", "rubygems_generators"))
    ]
  end

  def generator_path
    "app_generators"
  end
end
