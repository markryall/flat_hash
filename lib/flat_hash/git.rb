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
    execute "add -A"
    execute "ls-files --deleted -z | xargs -0 git rm"
    commit comment
  end

  def changesets path='.'
    sh("git log --format=%H -- #{path}") do |status, lines|
      raise "failed with status #{status}:\n#{lines.join("\n")}" unless status.exitstatus == 128
      []
    end
  end

  def changeset id
    change = FlatHash::Changeset.new
    commit = git.commit(id)
    change.id = commit.sha
    change.time = commit.date
    change.author = commit.author.to_s
    all_changes = execute("show --pretty=\"format:\" --name-only #{commit}")
    all_changes.shift
    change.additions = commit.diffs.select {|diff| diff.new_file}.map {|diff| diff.a_path }.uniq
    change.deletions = []
    change.modifications = []
    all_changes.each do |path|
      if commit_contains(commit,path)
        change.modifications << path
      else
        change.deletions << path
      end
    end
    change.modifications = change.modifications - change.additions
    change.description = commit.message
    change
  end

  def content_at path, commit
    execute("show #{commit}:#{path}").join("\n")
  end

  def files_at commit, path=nil
    tree = git.commit(commit).tree
    tree = tree/path if path
    tree ? tree.blobs.map {|blob| path ? "#{path}/#{blob.name}" : blob.name } : []
  end

  def contains? id, path
    commit_contains git.commit(id), path
  end
private
  def commit_contains commit, path
    commit.tree/path
  end
end