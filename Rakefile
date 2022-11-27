require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc "辞書生成"
task :generate do
  require "./lib/skk_sts_dic"
  SkkStsDic::Generator.new.generate
end
