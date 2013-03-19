# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
puts 'DEFAULT USERS AND THEIR PROJECTS'
#user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
#puts 'user: ' << user.name
#user.confirm!
#user.add_role :admin
users = [{name: 'Jack', email: 'jack@example.com', password: '12345678', password_confirmation: '12345678'},
{name: 'Rose', email: 'rose@example.com', password: '12345678', password_confirmation: '12345678'}]
projects = [{name: 'CSI 5100', description: 'Software testing techniques', manager: 'Jack', due_at: DateTime.new(2013,6,1,23,59,59)},
{name: 'ELG 5369', description: 'Internetworking techniques', manager: 'Rose', due_at: DateTime.new(2013,5,1,23,59,59)},
{name: 'ELG 5111', description: 'Multimedia techniques', manager: 'Jack', due_at: DateTime.new(2012,12,1,23,59,59)}]
tasks = [{name: 'inception', tag: 0, due_at: DateTime.new(2013,4,1,23,59,59)},
{name: 'elaboration', tag: 1, due_at: DateTime.new(2013,4,15,23,59,59)},
{name: 'implementation', tag: 2, due_at: DateTime.new(2013,5,1,23,59,59)},
{name: 'production', tag: 3, due_at: DateTime.new(2013,5,15,23,59,59)}]
users.each do |u|
	user = User.find_or_create_by_name(name: u[:name], email: u[:email], password: u[:password], password_confirmation: u[:password_confirmation])
	puts 'user: ' << user.name
	user.confirm!
	projects.each do |p|
		project = user.projects.create(name: p[:name], description: p[:description], manager: p[:manager], due_at: p[:due_at])
		puts 'project: ' << project.name
		tasks.each do |t|
			task = project.tasks.create(name: t[:name], tag: t[:tag], due_at: t[:due_at])
			puts 'task: ' << task.name
		end
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
  record.created_at = Time.at(Time.now + rand(Time.now.months_since(2).to_f - Time.now.to_f))
  record.save
  print '.'
end

