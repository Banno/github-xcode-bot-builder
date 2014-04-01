require 'json'
require 'pp'

Repository = Struct.new(:github_url, :github_repo, :xcode_scheme, :xcode_project_or_workspace) do
end

XCode = Struct.new(:server, :run_analyzer, :run_tests, :create_archive, :unit_test_devices) do
end

class BotConfiguration
	attr_accessor :github_access_token
	attr_accessor :repos
	attr_accessor :xcode

	def initialize(fileName)
		@filename = File.expand_path(fileName)
		@data = JSON.parse(File.read(@filename))
		@github_access_token = @data["github_access_token"]
		load_xcode
		load_repos
	end

	def load_xcode
		@xcode = XCode.new(@data['xcode_server'], @data['xcode_run_analyzer'], @data['xcode_run_tests'], @data['xcode_create_archive'], @data['unit_test_devices'])
	end

	def load_repos
		repos = @data["repos"]

		if repos.nil?
			puts "Could not load repos, for they do not exist."
			@repos = nil
		else
			@repos = repos.collect do |repo|
				Repository.new(repo["github_url"], repo["github_repo"], repo["xcode_scheme"], repo["xcode_project_or_workspace"])
			end
		end
	end
end


if __FILE__ == $0
	c = BotConfiguration.new('~/Desktop/test.json')
	pp c.repos
end
