require 'test_helper'

def should_have_file(file)
  should "have file #{file}" do
    full_path = "checkout/cms/#{file}"
    assert File.exists?(full_path), "expected to find file #{full_path}, but did not"
  end
end

class OurTest < Test::Unit::TestCase
  context 'Given a repo named cms with a trunk with two files file1 and file2' do
    setup do
      @repo = repo!(:cms)
      add! 'trunk/file1'
      add! 'trunk/file2'
    end
    
    teardown do
      delete!
    end
    
    context 'for which we have a local checkout of the trunk' do
      setup do
        checkout!(:cms, 'trunk')
      end
      
      should_have_file 'trunk/file1'
      should_have_file 'trunk/file2'
      
    end
    
    context 'when we branch trunk to branches/feature_branch' do
      setup do
        branch! :feature_branch
      end
      
      # should 'be able to checkout the branch' do
      #   checkout!(:cms, 'feature_branch')
      #   should_have_file
      # end
    end
    
  end
end