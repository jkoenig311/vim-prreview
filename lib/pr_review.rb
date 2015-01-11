require 'octokit'
require_relative 'github'

GITHUB_TOKEN=ENV['GITHUB_TOKEN']
GITHUB_USERNAME=ENV['GITHUB_USERNAME']

class PrReview

  def self.current
    @current
  end

  def initialize()
    Octokit.configure do |c|
      c.login = GITHUB_USERNAME
      c.password = GITHUB_TOKEN
    end
    $pulls
  end

  def self.print_pull_requests
    @current = new()
    options = { :state     => 'open',
                :labels    => 'Needs QA',
                :sort      => 'updated',
                :direction => 'asc'
    }
    $pulls =  Octokit.issues('thinkthroughmath/apangea', options )
    @current.print $pulls
  end

  def print pulls
    b = VIM::Buffer.current
    pulls.reverse_each do |pull|
      date = pull.updated_at
      title = pull.title.strip
     b.append(0, "#{date}: #{title}")
    end
  end

  def commits
    pull = Octokit.pull 'thinkthroughmath/apangea', 1828
    commits = Octokit.pull_commits 'thinkthroughmath/apangea', 1828

    #branch_name = pull.head.ref
  end

  def browse line_number
    url = $pulls[line_number].html_url
    Vim.command "call netrw#NetrwBrowseX(\"#{url}\",0)"
  end
end