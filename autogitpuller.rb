require 'rubygems'
require 'json'
require 'yaml'

puts "Starting automatic Github/Bitbucket backupping tool!"

config_file = File.expand_path('~') + "/.autogitpuller.yaml"

if !File.file? config_file
	puts "*** Error ***"
	puts "Configuration file missing!"
	puts "Now creating configuration file for you..."
	puts "Please update ~/.autogitpuller.yaml and run this command again."

	File.open(config_file,'w') do |file|
		file.puts "directory: /path/to/backup/directory/"
		file.puts ""
		file.puts "repos:"
		file.puts "  - type: github "
		file.puts "    username: asdf"
		file.puts "    password: qwerty"
		file.puts ""
		file.puts "  - type: bitbucket"
		file.puts "    username: asdf"
		file.puts "    password: qwerty"
	end

	exit
end

$config = YAML.load_file(config_file)

def backupGithub(username,password)
	puts "Backupping Github/" + username
	command = "curl -s -u " + username + ":"+ password +" https://api.github.com/user/repos"
	output  = IO.popen(command)
	output  = output.readlines
	output  = output.join()
	data = JSON.parse(output)

	i = 0

	while i < data.length do
		puts "Github/"+username+"/"+data[i]["name"]

		directory = $config["directory"] + "github/" + username + "/" + data[i]["name"]

		if !File.directory? directory
			system("mkdir -p " + directory)

			system("git clone " + data[i]["ssh_url"] + " " + directory)
		else
			system("cd " + directory + " && git pull")
		end
		i += 1
	end
end

def backupBitbucket(username,password)
	puts "Backupping Bitbucket/" + username
	command = "curl -s -u " + username + ":"+ password +" curl https://api.bitbucket.org/1.0/users/" + username  + "/"
	output  = IO.popen(command)
	output  = output.readlines
	output  = output.join()
	data = JSON.parse(output)

	i = 0

	while i < data["repositories"].length do
		puts "Bitbucket/"+username+"/"+data["repositories"][i]["name"]

		directory = $config["directory"] + "bitbucket/" + username + "/" + data["repositories"][i]["name"]
		git_url   = "git@bitbucket.org:" + username + "/" + data["repositories"][i]["name"] + ".git"

		if data["repositories"][i]["scm"] == "git"

			if !File.directory? directory
				system("mkdir -p " + directory)

				system("git clone " + git_url + " " + directory) 
			else
				system("cd " + directory + " && git pull")
			end

		end
		i += 1
	end
end

i = 0

while i < $config["repos"].length do

	if $config["repos"][i]["type"].downcase == "github"
		backupGithub($config["repos"][i]["username"],$config["repos"][i]["password"])
	end

	if $config["repos"][i]["type"].downcase == "bitbucket"
		backupBitbucket($config["repos"][i]["username"],$config["repos"][i]["password"])
	end

	i += 1
end
