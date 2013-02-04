require 'rubygems'
require 'csv'

FILE_PATH = "roster.csv"

#require 'bundler/setup'
#require 'schema'
#require 'mysql'

arr = CSV.read("roster.csv", {:headers => true})

queues = %w(BK BR CC DC ES JE MC PC SM SY TD TC Grad1 Grad2 OC1 OC2)
#colleges = %w(BK BR CC DC ES JE MC PC SM SY TD TC)
command_list = []
mailman_command = "sudo /usr/local/mailman/bin/sync_members -f"

queues.each do |queue|
  emails = []
  queue_list = arr.find_all {|row| row["Queue"] == queue}.each do |row|
    emails << row["Yale Email"]
  end
    emails << "yahor.buben@yale.edu"
    emails << "derek.zhao@yale.edu"
    emails << "casey.watts@yale.edu"
    filename = "studtech-st-#{queue.downcase}"
    File.open(filename, 'w') {|f| f.write(emails.join("\n")) }
    command_list << "#{mailman_command} #{filename} #{filename}"
    puts queue
end


#Generate kilroy email list
# colleges.each do |college|
#   users = User.find(:all, :conditions => ["college = ?", college]) + User.find(:all, :conditions => ["queue = ? and job='Coord'", college])
#   emails = users.map(&:email).uniq
#   emails << "studtech-mgr@mailman.yale.edu"
#   emails << "studtech-css-asst@mailman.yale.edu"
#   filename = "studtech-st-#{college.downcase}-kilroy"
#   File.open(filename, 'w') {|f| f.write(emails.join("\n")) }
#   command_list << "#{mailman_command} #{filename} #{filename}"
# end

#Generate queue email list
# queues.each do |queue|
#   users = User.find(:all, :conditions => ["queue = ?", queue])
#   emails = users.map(&:email).uniq
#   emails << "studtech-mgr@mailman.yale.edu"
#   filename = "studtech-st-#{queue.downcase}"
#   File.open(filename, 'w') {|f| f.write(emails.join("\n")) }
#   command_list << "#{mailman_command} #{filename} #{filename}"
# end

#Generate 'all' email list
#queues.each do |queue|
  #users = User.find(:all, :conditions => ["college = ? OR queue = ?", queue, queue])
  #emails = users.map(&:email).uniq
  #emails << "decal@yale.edu"
  #if colleges.include? queue
    #emails << "yahor.buben@yale.edu"
  #end
  #filename = "studtech-st-#{queue.downcase}"
  #File.open(filename, 'w') {|f| f.write(emails.join("\n")) }
  #command_list << "#{mailman_command} #{filename} #{filename}"
#end

File.open("command_list", 'w') {|f| f.write("#!/bin/bash\n")}
File.open("command_list", 'a') {|f| f.write(command_list.join("\n"))}
