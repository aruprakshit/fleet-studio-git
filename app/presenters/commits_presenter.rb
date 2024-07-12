class CommitsPresenter
  def self.show(response)
    {
      oid: response[:sha],
      message: response[:commit][:message],
      author: user_details(response[:commit][:author]),
      committer: user_details(response[:commit][:committer]),
      parents: response[:parents].map { |hsh| { oid: hsh[:sha] } }
    }
  end

  private

  def self.user_details(data)
    {
      name: data[:name],
      email: data[:email],
      date: data[:date]
    }
  end
end