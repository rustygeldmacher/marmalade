require 'spec_helper'

describe ProjectBuilder do

  @@temp_dir = '/tmp'
  @@proj_name = 'foo'
  @@project_path = File.join(@@temp_dir, @@proj_name)

  before do
    clean_project_dir
    @builder = ProjectBuilder.new
    Dir.chdir(@@temp_dir) do
      @builder.create(@@proj_name)
    end
  end

  after do
    clean_project_dir
  end

  it "should create the project path" do
    File.exist?(@@project_path).should be_true
  end

  it "should create a main Ruby file with the name of the project" do
    project_file_exists?("#{@@proj_name}.rb").should be_true
  end

  it "should create a spec file with the name of the project" do
    project_file_exists?("#{@@proj_name}_spec.rb").should be_true
  end

  it "should create a Rakefile" do
    project_file_exists?("Rakefile").should be_true
  end

  def project_file_exists?(file_name)
    File.exist?(File.join(@@project_path, file_name))
  end

  def clean_project_dir
    FileUtils.rm_rf(@@project_path)
  end

end