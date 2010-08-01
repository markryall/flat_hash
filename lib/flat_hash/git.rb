require 'flat_hash/vcs'
require 'flat_hash/changeset'
require 'grit'

class FlatHash::Git < FlatHash::Vcs
  def git
    @git ||= Grit::Repo.new('.')
  end

  def name
    :git
  end

  def addremovecommit comment
    sh "git add -A"
    sh "git ls-files --deleted -z | xargs -0 git rm"
    commit comment
  end

  def history *path
    sh("git log --format=%H -- #{File.join(*path)}") do |status, lines|
      raise "failed with status #{status}:\n#{lines.join("\n")}" unless status.exitstatus == 128
      []
    end
  end
  alias :changesets :history

  def changeset id
    change = FlatHash::Changeset.new
    commit = git.commit(id)
    change.id = commit.sha
    change.time = commit.date
    change.author = commit.author.to_s
    #change.modifications = read_until(lines, 'additions:')
    #change.additions = read_until(lines, 'deletions:')
    #change.deletions = read_until(lines, 'description:')
    #change.modifications = change.modifications - change.additions
    #change.modifications = change.modifications - change.deletions
    change.description = commit.message
    change
  end

  def entry_at path, commit
    sh("git show #{commit}:#{path}").join("\n")
  end
  alias :content_at :entry_at

  def files_changed commit
    sh("git show --pretty=\"format:\" --name-only #{commit}")
  end
end