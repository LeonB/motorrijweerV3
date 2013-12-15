# Edit Rakefile in project root
#
# Add a new rake test task... E.g., rake test:lib, below everything else in that file...
# Alternatively, add a task in lib/tasks/ directory and plop in the same code
namespace :test do
  desc "Test lib source"
  Rake::TestTask.new(:lib) do |t|
    t.libs << "test"
    t.pattern = 'test/lib/**/*_test.rb'
    t.verbose = true
  end
end

lib_task = Rake::Task["test:lib"]
test_task = Rake::Task[:test]
test_task.enhance { lib_task.invoke }
