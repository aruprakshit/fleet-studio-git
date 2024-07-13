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
    response.files.map do |hsh|
      {
        "changeKind": hsh[:status],
        "headFile": {
          path: hsh[:filename]
        },
        "baseFile": {
          path: hsh[:filename]
        },
        "hunks": pretty_print_content(hsh[:patch].split("\n"))
        #"hunks": hsh[:patch].split("\n")
      }
    end
  end

  private

  def self.pretty_print_content(content)
    template = {header: '', lines: [], header_meta: {}}
    result = []
    data = nil

    content.each do |string|
      if string.starts_with?('@@')
        if data.nil?
          data = template.clone
          data[:header] = string
          data[:header_meta] = extract_hunk_header(string)
        else
          data.delete(:header_meta)
          result.push(data)
          data = template.clone
          data[:header] = string
          data[:header_meta] = extract_hunk_header(string)
        end
      else
        data[:lines].push({
          baseLineNumber: data[:header_meta][:old_file_start],
          headLineNumber: data[:header_meta][:old_file_start],
          content: string
        })
      end
    end
    data.delete(:header_meta)
    result.push(data)
    result
  end

  def self.user_details(data)
    {
      name: data[:name],
      email: data[:email],
      date: data[:date]
    }
  end

  def self.extract_hunk_header(string)
    re = /@@ ([\+\-]?\d+),([\+\-]?\d+) ([\+\-]?\d+),([\+\-]?\d+) @@/
    m = re.match(string)
    {
      old_file_start: m[1].to_i.abs,
      old_file_lines_included: m[2].to_i,
      new_file_start: m[3].to_i,
      new_file_lines_included: m[4].to_i
    }
  end
end