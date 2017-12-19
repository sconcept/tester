require 'cucumber/rake/task'
require 'fileutils'
require 'cucumber'
require 'report_builder'

task default: 'all'

desc 'Runing all tests tagged with @regression'
Cucumber::Rake::Task.new(:all, 'Runs all tests') do |t|
  t.cucumber_opts = "./
    --format html --out=test_artifacts/regression-report-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.html
    --format pretty --no-source
    --format rerun --out test_artifacts/all-rerun.txt
    --tag @regression"
end

desc 'Running all tests tagged with @smoke'
Cucumber::Rake::Task.new(:smoke, 'Runs the smoke test suite') do |t|
  t.cucumber_opts = "./
    --format html --out=test_artifacts/smoke-report-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.html
    --format pretty --no-source
    --format rerun --out test_artifacts/smoke-rerun.txt
    --tag @smoke"
end

desc 'Parallel execution of all feature files'

# Run this from jenkins / locally after you have ran parallel_cucumber and pass in both paths
desc 'Build reporting html front end from parallel gem split json files'
task :report_builder, [:json_path, :report_path] do |_t, args|
  args.with_defaults(json_path: 'testartifacts/results', report_path: 'testartifacts/reports/test_run_report')
  options = { json_path: args.json_path, report_path: args.report_path }
  ReportBuilder.build_report options
end

# Run this after you have generated a report html frontend from :report_builder
desc 'Parse results of the run and forward them onto a slack channel'
