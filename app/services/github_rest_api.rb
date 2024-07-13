class GithubRestApi
  TOKEN = Rails.application.credentials.dig(:github, :pat)

  attr_reader :client

  def initialize
    @client = Octokit::Client.new(:access_token => TOKEN)
  end

  def get_commit(owner:, repository:, sha:)
    repo = Octokit::Repository.new(owner: owner, name: repository)
    response = client.commit(repo, sha)
  end

  def get_commit_diff(owner:, repository:, sha:)
    repo = Octokit::Repository.new(owner: owner, name: repository)
    response = client.compare(repo, "#{sha}^", sha)
    # https://octokit.github.io/octokit.rb/Octokit/Client/Commits.html#compare-instance_method
  end
end