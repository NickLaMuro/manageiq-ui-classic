namespace :cypress do
  desc "Run cypress tests"
  task :ui => 'ui:run'

  namespace :ui do
    desc "Seed database/configure assets for cypress specs"
    task :seed do |rake_task|
      app_prefix = rake_task.name.chomp('cypress:ui:seed')
      Rake::Task["#{app_prefix}integration:seed"].invoke
    end

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

    desc "Run cypress tests in 'development' mode"
    task :dev => 'dev:run'

    # Aliases for running with CYPRESS_DEV
    namespace :dev do
      desc "'Development Mode' for cypress:ui:seed"
      task :seed  => [:env, 'cypress:ui:seed']

      desc "'Development Mode' for cypress:ui:open"
      task :open  => [:env, 'cypress:ui:open']

      desc "'Development Mode' for cypress:ui:run"
      task :run   => [:env, 'cypress:ui:run']

      desc "'Development Mode' for cypress:ui:setup"
      task :setup => [:env, 'cypress:ui:setup']

      # Helper task to defaulte the CYPRESS_DEV env var to "1"
      task :env do
        ENV["CYPRESS_DEV"] = "1"
      end
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
