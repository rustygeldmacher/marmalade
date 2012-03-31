require 'spec_helper'

describe ProjectBuilder do

  TEMP_DIR = '/tmp'
  PROJ_NAME = 'foo'
  PROJ_PATH = File.join(TEMP_DIR, PROJ_NAME)

  before do
    clean_project_dir
    @builder = ProjectBuilder.new
    # Stub out puts so we don't get any output when we run tests
    @builder.stubs(:puts)
    Dir.chdir(TEMP_DIR) do
      @builder.create(PROJ_NAME)
    end
  end

  after do
    clean_project_dir
  end

  it "should create the project path" do
    File.exist?(PROJ_PATH).should be_true
  end

  it "should create a main Ruby file with the name of the project" do
    project_file_exists?("#{PROJ_NAME}.rb").should be_true
  end

  it "should create a spec file with the name of the project" do
    project_file_exists?("#{PROJ_NAME}_spec.rb").should be_true
  end

  it "should create a Rakefile" do
    project_file_exists?("Rakefile").should be_true
  end

  def project_file_exists?(file_name)
    File.exist?(File.join(PROJ_PATH, file_name))
  end

  def clean_project_dir
    FileUtils.rm_rf(PROJ_PATH)
  end

end