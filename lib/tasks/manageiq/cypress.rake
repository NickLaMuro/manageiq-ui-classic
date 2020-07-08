namespace :cypress do
  desc "Run cypress tests"
  task :ui => 'ui:run'

  namespace :ui do
    desc "Interactively run cypress tests"
    task :open => ['ui:setup'] do
      sh "#{yarn_cmd} cypress open"
    end

    desc "Run headless cypress tests"
    task :run => ['ui:setup'] do
      sh "#{yarn_cmd} cypress run --headless --browser firefox --config video=false"
    end

    task :setup do |rake_task|
      app_prefix = rake_task.name.chomp('cypress:ui:setup')
      Rake::Task["#{app_prefix}integration:with_ui"].invoke
      Rake::Task["#{app_prefix}integration:ui_ready"].invoke
    end

    def yarn_cmd
      cmd = "yarn"

      unless defined?(ENGINE_ROOT)
        cmd += " --cwd #{File.expand_path(File.join(*%w[.. .. ..]), __dir__)}"
      end

      cmd
    end
  end
end
