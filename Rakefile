# To get a list of all tasks, execute:
#
#  rake -T
#
# Now you're Awestruct with rake!

$rakebin = ".bin#{File::SEPARATOR}forrake"
$awestruct_cmd = nil
task :default => :preview

desc 'Setup the environment to run Awestruct using Bundler'
task :setup, [:env] => :init do |task, args|
  system "bundle install --binstubs=#{$rakebin} --path=.bundle"
  msg 'Run awestruct `rake`'
  # Don't execute any more tasks, need to reset env
  exit 0
end

desc 'Update the environment to run Awestruct'
task :update => :init do
  system 'bundle update'
  # Don't execute any more tasks, need to reset env
  exit 0
end

desc 'Build and preview the site locally in development mode'
task :preview do
  run_awestruct '-d'
end

desc 'Generate the site using the specified profile, default is \'development\''
task :gen, :profile do |task, args| 
  if args[:profile].nil?
    profile = "development"
  else
    profile = args[:profile]
  end
  run_awestruct "-P #{profile} -g --force"
end

desc 'Push local commits to origin/master'
task :push do
  system 'git push upstream master'
end

desc 'Clean out generated site and temporary files, using [all] will also delete local gem files' 
task :clean, :all do |task, args|
  require 'fileutils'
  dirs = ['.awestruct', '.sass-cache', '_site']
  if args[:all] == 'all'
    dirs << '_tmp'
    dirs << '.bundle'
    dirs << "#{$rakebin}"
  end
  dirs.each do |dir|
    FileUtils.remove_dir dir unless !File.directory? dir
  end
end

# desc 'Run Rspec tests'
# task :test do
#   all_ok = system "bundle exec rspec _spec --format nested"
#   if all_ok == false
#     fail "RSpec tests failed - aborting build"
#   end
# end
# 
# Perform initialization steps, such as setting up the PATH
task :init do
  # Detect using gems local to project
  if File.exist? "#{$rakebin}"
    ENV['PATH'] = "#{$rakebin}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
    ENV['GEM_HOME'] = '.bundle'
  end
end

desc 'Check to ensure the environment is properly configured'
task :check => :init do
  begin
    require 'bundler'
    Bundler.setup
    msg 'Ready to go.'
  rescue LoadError
    msg 'Bundler gem not installed. Run \'gem install bundler first\''
  rescue StandardError => e
    msg e.message, :warn
    if which('awestruct').nil?
      msg 'Run `rake setup` or `rake setup[local]` to install required gems from RubyGems.'
    else
      msg 'Run `rake update` to install additional required gems from RubyGems.'
    end
    exit e.status_code
  end
end

# Execute Awestruct
def run_awestruct(args)
  cmd = "bundle exec awestruct #{args}" 
  msg cmd
  system cmd or raise "ERROR: Running Awestruct failed."
end

# A cross-platform means of finding an executable in the $PATH.
# Respects $PATHEXT, which lists valid file extensions for executables on Windows
#
#  which 'awestruct'
#  => /usr/bin/awestruct
def which(cmd, opts = {})
  unless $awestruct_cmd.nil? || opts[:clear_cache]
    return $awestruct_cmd
  end

  $awestruct_cmd = nil
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each do |ext|
      candidate = File.join path, "#{cmd}#{ext}"
      if File.executable? candidate
        $awestruct_cmd = candidate
        return $awestruct_cmd
      end
    end
  end
  return $awestruct_cmd
end

# Print a message to STDOUT
def msg(text, level = :info)
  case level
  when :warn
    puts "\e[31m#{text}\e[0m"
  else
    puts "\e[33m#{text}\e[0m"
  end
end

