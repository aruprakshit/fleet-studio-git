require 'open-uri'

class GitDiffPresenter
  def initialize(url)
    @diff_content = URI.open(url) {|f|
      f.read
    }
  end

  def process
    parsed_diffs = GithubDiffParser.parse(@diff_content)
    result = parsed_diffs.map do |diff_instance|
      {
        changeKind: diff_instance.mode.operation,
        headFile: {
          path: diff_instance.new_filename
        },
        baseFile: {
          path: diff_instance.previous_filename
        },
        hunks: build_hunks(diff_instance.hunks)
      }
    end
  end

  private

  def build_hunks(hunks)
    hunks.map do |hunk_obj|
      {
        header: '',
        lines: hunk_obj.lines.map do |line_obj|
          {
            baseLineNumber: line_obj.previous_number,
            headLineNumber: line_obj.current_number,
            content: line_obj.content
          }
        end
      }
    end
  end
end