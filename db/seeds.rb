# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
# puts 'ROLES'
# YAML.load(ENV['ROLES']).each do |role|
#   Role.find_or_create_by_name({ :name => role }, :without_protection => true)
#   puts 'role: ' << role
# end
puts 'DEFAULT USERS'
# user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
# puts 'user: ' << user.name
# user.confirm!
# user.add_role :admin
users = {'0' => {name: 'Jack', email: 'jack@example.com', password: '12345678', password_confirmation: '12345678'},
         '1' => {name: 'Rose', email: 'rose@example.com', password: '12345678', password_confirmation: '12345678'}}
created_at = [DateTime.new(2011,7,26,17,25,0), DateTime.new(2011,8,11,11,50,0)]
# confirmed_at = [DateTime.new(2011,7,26,17,26,0), DateTime.new(2011,8,11,11,51,0)]
users.each do |i, u|
  user = User.find_or_create_by_name(name: u[:name], email: u[:email], password: u[:password], password_confirmation: u[:password_confirmation])
  # user.confirm!
  user.created_at = created_at[i.to_i]
  # user.confirmed_at = confirmed_at[i.to_i]
  user.save
  puts 'user: ' << user.name
end
puts 'DEFAULT PROJECTS AND TASKS'
projects = {'0' => {name: 'CSI 5111', description: 'Software Quality Engineering', manager: 'Jack'},
            '1' => {name: 'ELG 5369', description: 'Internetworking Technologies', manager: 'Rose'},
            '2' => {name: 'ELG 5100', description: 'Software Engineering Project Management', manager: 'Jack'}}
tasks = {'0' => {name: 'inception', tag: 0}, '1' => {name: 'elaboration', tag: 1}, 
         '2' => {name: 'implementation', tag: 2}, '3' => {name: 'production', tag: 3}}
created_at = [DateTime.new(2011,9,25,10,0,0), DateTime.new(2011,10,4,14,30,0), DateTime.new(2013,4,1,21,15,0)]
due_at = [DateTime.new(2011,12,15,0,0,0), DateTime.new(2011,12,10,0,0,0), DateTime.new(2013,9,1,0,0,0)]
tasks_created_at = []
tasks_due_at = []
tasks_created_at << [DateTime.new(2011,9,27,16,25,0), DateTime.new(2011,10,4,21,30,0), DateTime.new(2013,4,1,13,35,0)]
tasks_due_at << [DateTime.new(2011,10,15,0,0,0), DateTime.new(2011,10,21,0,0,0), DateTime.new(2013,5,20,0,0,0)]
tasks_created_at << [DateTime.new(2011,10,2,11,55,0), DateTime.new(2011,10,18,1,30,0), DateTime.new(2013,5,22,23,35,0)]
tasks_due_at << [DateTime.new(2011,11,15,0,0,0), DateTime.new(2011,11,1,0,0,0), DateTime.new(2013,7,10,0,0,0)]
tasks_created_at << [DateTime.new(2011,11,17,8,45,0), DateTime.new(2011,11,4,22,35,0), DateTime.new(2013,7,5,22,15,0)]
tasks_due_at << [DateTime.new(2011,11,30,0,0,0), DateTime.new(2011,12,1,0,0,0), DateTime.new(2013,8,5,0,0,0)]
tasks_created_at << [DateTime.new(2011,11,27,13,25,0), DateTime.new(2011,11,27,20,10,0), DateTime.new(2013,7,28,11,55,0)]
tasks_due_at << [DateTime.new(2011,12,15,0,0,0), DateTime.new(2011,12,10,0,0,0), DateTime.new(2013,9,1,0,0,0)]
projects.each do |i, p|
  project = Project.find_or_create_by_name(name: p[:name], description: p[:description], manager: p[:manager], due_at: DateTime.new(2013,1,1))
  project.created_at = created_at[i.to_i]
  project.due_at = due_at[i.to_i]
  project.save
  puts 'project: ' << project.name
  tasks.each do |j, t|
    task = project.tasks.find_or_create_by_name(name: t[:name], tag: t[:tag], due_at: DateTime.new(2013,1,1))
    task.created_at = tasks_created_at[j.to_i][i.to_i]
    task.due_at = tasks_due_at[j.to_i][i.to_i]
    task.save
    puts 'task: ' << task.name
  end
end
users = User.all
projects = Project.all
users.each do |user|
  projects.each do |project|
    user.projects << project
  end
end
puts 'DEFAULT RECORDS'
users_ids = []
users = User.all
users.each do |user|
  users_ids << user.id
end
tasks_ids = []
tasks = Task.all
tasks.each do |task|
  tasks_ids << task.id
end
100.times do
  record = Record.create(description: 'one record', hours: (rand()*8).round(1))
  record.user_id = users_ids.sample
  record.task_id = tasks_ids.sample
  task = Task.find(record.task_id)
  record.created_at = Time.at(task.created_at + rand(task.due_at.to_f - task.created_at.to_f))
  record.save
  print '.'
end

