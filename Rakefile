require 'rake/testtask'
require 'find'
require 'bundler/gem_tasks'

desc 'Say hello'
task :hello do
  puts "Hello there. This is the 'hello' task."
end

desc 'Run tests'
task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'List all files'
task :list_files do
  files = []
  Find.find("/home/nickperry12/launch_school/todolist_project/") do |path|
    next if path.include?('/.')
    if File.file?(path)
      files << path unless path.start_with?('.')
    end
  end
  puts files
end