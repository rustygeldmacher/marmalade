require 'fileutils'

# Builds a project scaffolding
# TODO: Currently Ruby 1.9-only -- make this work with 1.8
class ProjectBuilder

  def create(project_name)
    template_path = File.join(File.expand_path('../../../', __FILE__), 'templates')

    # Create project directory
    Dir.mkdir(project_name)

    # Copy all template files into it
    main_file = File.join(project_name, "#{project_name}.rb")
    FileUtils.copy(File.join(template_path, 'main.rb'), main_file)
    FileUtils.copy(File.join(template_path, 'main_spec.rb'), File.join(project_name, "#{project_name}_spec.rb"))
    FileUtils.copy(File.join(template_path, 'Rakefile'), File.join(project_name, 'Rakefile'))
  end

end
