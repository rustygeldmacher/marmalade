require 'fileutils'

# Builds a project scaffolding
# TODO: Currently Ruby 1.9-only -- make this work with 1.8
class ProjectBuilder

  def create(project_name)
    template_path = File.join(File.expand_path('../../../', __FILE__), 'templates')

    # Create project directory
    puts "Creating directory #{project_name}"
    Dir.mkdir(project_name)

    # Copy all template files into it
    main_file = File.join(project_name, "#{project_name}.rb")
    copy_file(File.join(template_path, 'main.rb'), main_file)
    copy_file(File.join(template_path, 'main_spec.rb'), File.join(project_name, "#{project_name}_spec.rb"))
    copy_file(File.join(template_path, 'Rakefile'), File.join(project_name, 'Rakefile'))
  end

  private

  def copy_file(from, to)
    puts "Creating #{to}"
    FileUtils.copy(from, to)
  end

end
