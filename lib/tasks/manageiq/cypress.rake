namespace :spec do
  desc "Run integration tests"
  task :cypress do
    cypress_index = ManageIQ::UI::Classic::Engine.root.join("cypress/support/index.js")
    disable_screenshot_string = <<~DISABLE_SCREENSHOT
      Cypress.Screenshot.defaults({
        screenshotOnRunFailure: false
      })
    DISABLE_SCREENSHOT

    File.open(cypress_index, 'a') do |f|
      f << disable_screenshot_string
    end

    system('yarn cypress:run --config video=false')
    exit $CHILD_STATUS.exitstatus
  end
end
