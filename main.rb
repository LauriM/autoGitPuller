require 'rubygems'
require 'json'
require 'yaml'

puts "Starting automatic Github/Bitbucket backupping tool!"

puts "Reading configs from ./config.yaml"
$config = YAML.load_file("config.yaml")


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
			# Directory doesn't exists yet, create it
			system("mkdir -p " + directory)

			# Do a starting clone
			system("git clone " + data[i]["ssh_url"] + " " + directory)
		else
			# Directory has already been created pull to it
			system("cd " + directory + " && git pull origin master")
		end
		i += 1
	end
end

i = 0

while i < $config["repos"].length do

	if $config["repos"][i]["type"] == "Github"
		backupGithub($config["repos"][i]["username"],$config["repos"][i]["password"])
	end

	i += 1
end
