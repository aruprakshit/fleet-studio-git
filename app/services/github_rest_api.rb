class GithubRestApi
  TOKEN = Rails.application.credentials.dig(:github, :pat)

  attr_reader :client

  def initialize
    @client = Octokit::Client.new(:access_token => TOKEN)
  end

  def get_commit(owner:, repository:, sha:)
    #repo = "https://github.com/#{owner}/#{repository}.git"
    repo = Octokit::Repository.new(owner: owner, name: repository)
    response = client.commit(repo, sha)
  end
end