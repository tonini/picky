require 'spec_helper'

describe Index::File::Basic do
  
  before(:each) do
    @file = Index::File::Basic.new "some/cache/path/to/file"
  end
  
  describe "backup_file_path_of" do
    it "returns a backup path relative to the path" do
      @file.backup_file_path_of('some/path/to/some.index').should == 'some/path/to/backup/some.index'
    end
  end
  
end