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

  def self.diff(response)
    diffs = GitDiffPresenter.new(response[:diff_url]).process
    response[:files].each_with_index do |file, idx|
      headers = file[:patch].split("\n").select {|string| string.starts_with?('@@') }
      headers.each_with_index do |header, header_idx|
        diffs[idx][:hunks][header_idx][:header] = header
      end
    end

    diffs
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