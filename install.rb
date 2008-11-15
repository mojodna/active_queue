FileUtils.mkdir(File.join(RAILS_ROOT, "app", "active_queue"))
FileUtils.cp(File.join(RAILS_ROOT, "vendor", "plugins", "active_queue", "bin", "queue_runner"), File.join(RAILS_ROOT, "script"))

puts "ActiveQueue has been installed."
puts "queue_runner is available in script/"
