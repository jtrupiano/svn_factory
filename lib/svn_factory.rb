# Starting to change my mind here-- thinking that what we really need is
# a library for manipulating checkouts of existing repositories.  The
# svn_repos library should still be good as a factory, but we'll also
# need something for managing a local checkout

require 'svn_factory/svn_repos'
# require 'svn_factory/server'
# require 'svn_factory/client'

CWD = "./" #File.dirname(__FILE__)

# Factory methods for creating and manipulating subversion
module SvnFactory
  module Server
  
    PATH = File.join(File.dirname(__FILE__), 'repo')
  
    # creates a repo that will persist until a teardown is called
    def repo!(name='blah')
      path = File.join(PATH, name.to_s)
      FileUtils::mkdir_p(path)
      delete!(name)

      @repos ||= {}
      @current_repo = name.to_sym
      @repos[@current_repo] = SvnRepos.create(path)
    end
  
    def add!(path, contents="Sample contents")
      current_repo.commit({path.to_s => contents})
    end
  
    alias update! add!
  
    def delete!(name='blah')
      path = File.join(PATH, name.to_s)
      SvnRepos.delete!(path) if SvnRepos.repository_exists?(path)
    end
  
    def branch!(branch_name, &block)
    
    end
  
    def current_repo
      @repos[@current_repo]
    end
  end

  # Factory methods for checking out and manipulating a real filesystem
  # checkout of subversion repos
  module Client
  
    PATH = File.join(File.dirname(__FILE__), 'checkout')
  
    def checkout!(name='blah', path_from_repo_root='')
      path = File.join(PATH, name.to_s, path_from_repo_root)
      FileUtils::rm_rf path
      remote_path = File.join(SvnFactory::Server::PATH, name.to_s, path_from_repo_root)
      FileUtils::mkdir_p(path)
      `svn checkout file:///\`pwd\`/#{remote_path} #{path}`
    end
  
  end
end

Test::Unit::TestCase.send(:include, SvnFactory::Server)
Test::Unit::TestCase.send(:include, SvnFactory::Client)
  