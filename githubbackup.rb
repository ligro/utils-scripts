#!/usr/bin/ruby
#gitback 0.1
#credits: Walter White, Updates: Addy Osmani
#!/usr/bin/env ruby
# dependencies
require "json"
require "open-uri"
# your github username
username = "ligro"
time = Time.new
# feel free to comment out the option you don't wish to use.
backupDirectory = "/home/ligro/otherProjects/github/"
#or simply: backupDirectory = "/backups/github/"
#repositories =
# .map{|r| %Q[#{r["name"]}] }
#FileUtils.mkdir_p #{backupDirectory}
JSON.load(open("https://api.github.com/users/#{username}/repos")).map{|repository|
    if not File.directory?(backupDirectory + repository["name"])
        puts "discovered repository: #{repository["name"]} ... backing up ..."
        #exec
        puts "git clone git@github.com:#{username}/#{repository["name"]}.git #{backupDirectory}#{repository["name"]}"
        system "git clone git@github.com:#{username}/#{repository["name"]}.git #{backupDirectory}#{repository["name"]}"
    end
}
