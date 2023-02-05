namespace :demo do
  desc "Runs the demo."
  task run: :environment do
    Demo.new.run
  end
end
