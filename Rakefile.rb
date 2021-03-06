require 'rubygems'
#Gem::manage_gems

require 'rubygems/package_task'
require 'rdoc/task'

task :default => [:rdoc, :package]

#generate the gem package
spec = Gem::Specification.new do |s|
  s.name = "rubypost"
  s.version = "0.1.0"
  s.author = "Robby McKilliam"
  s.email = "robby.mckilliam@gmail.com"
  s.homepage = "https://github.com/robbymckilliam/rubypost"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby wrapper for the MetaPost drawing language"
  s.files = FileList["{tests,lib,doc}/*"].exclude("rdoc").to_a
  s.require_path = "lib"
  s.autorequire = "lib/rubypost"
  s.rubyforge_project = "rubypost"
  s.test_file = "tests/test_path.rb"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = false
  pkg.need_zip = false
end

#generate the documentation
Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/*.rb")
  rd.options << "--all"
  rd.rdoc_dir = "doc"
end
