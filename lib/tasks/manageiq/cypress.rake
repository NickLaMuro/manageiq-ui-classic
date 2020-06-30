namespace :spec do
  desc "Run integration tests"
  task :cypress => 'cypress:run'

  namespace :cypress do
    desc "Interactively run integration tests"
    task :open => ['cypress:setup'] do
      sh 'yarn cypress open'
    end

    desc "Run headless integration tests"
    task :run => ['cypress:setup'] do
      sh 'yarn cypress run --headless --browser firefox --config video=false'
    end

    task :setup do |rake_task|
      app_prefix = rake_task.name.chomp('spec:cypress:setup')
      Rake::Task["#{app_prefix}integration:with_ui"].invoke
      Rake::Task["#{app_prefix}integration:ui_ready"].invoke
    end
  end
end
