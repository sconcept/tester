require 'cucumber/rake/task'
require 'fileutils'
FileUtils::mkdir_p 'results'

task :default => 'all'

Cucumber::Rake::Task.new(:all, 'Runs all tests') do |t|
  t.cucumber_opts = "features/*.feature
    --format html --out=results/all-report-#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.html
    --format pretty --no-source
    --format rerun --out results/all-rerun.txt
    --tag @regression"
end

Cucumber::Rake::Task.new(:smoke, 'Runs the smoke test suite') do |t|
  t.cucumber_opts = "features/*.feature
    --format html --out=results/smoke-report-#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.html
    --format pretty --no-source
    --format rerun --out results/smoke-rerun.txt
    --tag @smoke"
end

task :random do
  puts ENV['DRIVER']
end
