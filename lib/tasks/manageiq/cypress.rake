namespace :spec do
  desc "Run integration tests"
  task :cypress do
    sh 'yarn cypress run --headless --browser firefox --config video=false'
  end
end
