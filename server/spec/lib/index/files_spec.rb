require 'spec_helper'

describe Index::Files do

  before(:each) do
    @files_class = Index::Files
    @files       = @files_class.new :some_name, :some_category, :some_type
    
    @prepared    = @files.prepared
    
    @index       = @files.index
    @similarity  = @files.similarity
    @weights     = @files.weights
  end

  describe 'create_directory' do
    it 'should use makedirs to create the necessary directory structure' do
      FileUtils.should_receive(:mkdir_p).once.with 'some/search/root/index/test/some_type'

      @files.create_directory
    end
  end

  describe 'cache_directory' do
    it 'should be correct' do
      @files.cache_directory.should == 'some/search/root/index/test/some_type'
    end
  end
  
  describe "retrieve" do
    it "delegates to the prepared" do
      @prepared.should_receive(:retrieve).once.with
      
      @files.retrieve
    end
  end
  
  describe "dump indexes" do
    describe "dump_index" do
      it "uses the right file" do
        @index.should_receive(:dump).once.with :some_hash
        
        @files.dump_index :some_hash
      end
    end
    describe "dump_similarity" do
      it "uses the right file" do
        @similarity.should_receive(:dump).once.with :some_hash
        
        @files.dump_similarity :some_hash
      end
    end
    describe "dump_weights" do
      it "uses the right file" do
        @weights.should_receive(:dump).once.with :some_hash
        
        @files.dump_weights :some_hash
      end
    end
  end
  
  describe "loading indexes" do
    before(:each) do
      @files.stub! :timed_exclaim
    end
    describe "load_index" do
      it "uses the right file" do
        Yajl::Parser.stub! :parse
        
        File.should_receive(:open).once.with 'some/search/root/index/test/some_type/some_name_some_category_index.json', 'r'
        
        @files.load_index
      end
    end
    describe "load_similarity" do
      it "uses the right file" do
        Marshal.stub! :load
        
        File.should_receive(:open).once.with 'some/search/root/index/test/some_type/some_name_some_category_similarity.dump', 'r:binary'
        
        @files.load_similarity
      end
    end
    describe "load_weights" do
      it "uses the right file" do
        Yajl::Parser.stub! :parse
        
        File.should_receive(:open).once.with 'some/search/root/index/test/some_type/some_name_some_category_weights.json', 'r'
        
        @files.load_weights
      end
    end
  end
  
  describe "dump indexes" do
    describe "index_cache_ok?" do
      it "uses the right method" do
        @index.should_receive(:cache_ok?).once.with
        
        @files.index_cache_ok?
      end
    end
    describe "similarity_cache_ok?" do
      it "uses the right method" do
        @similarity.should_receive(:cache_ok?).once.with
        
        @files.similarity_cache_ok?
      end
    end
    describe "weights_cache_ok?" do
      it "uses the right method" do
        @weights.should_receive(:cache_ok?).once.with
        
        @files.weights_cache_ok?
      end
    end
  end
  
  describe "dump indexes" do
    describe "index_cache_small?" do
      it "uses the right method" do
        @index.should_receive(:cache_small?).once.with
        
        @files.index_cache_small?
      end
    end
    describe "similarity_cache_small?" do
      it "uses the right method" do
        @similarity.should_receive(:cache_small?).once.with
        
        @files.similarity_cache_small?
      end
    end
    describe "weights_cache_small?" do
      it "uses the right method" do
        @weights.should_receive(:cache_small?).once.with
        
        @files.weights_cache_small?
      end
    end
  end
  
  describe 'backup' do
    it 'should call backup on all' do
      @index.should_receive(:backup).once.with
      @similarity.should_receive(:backup).once.with
      @weights.should_receive(:backup).once.with
      
      @files.backup
    end
  end
  describe 'restore' do
    it 'should call delete on all' do
      @index.should_receive(:restore).once.with
      @similarity.should_receive(:restore).once.with
      @weights.should_receive(:restore).once.with
      
      @files.restore
    end
  end
  describe 'delete' do
    it 'should call delete on all' do
      @index.should_receive(:delete).once.with
      @similarity.should_receive(:delete).once.with
      @weights.should_receive(:delete).once.with
      
      @files.delete
    end
  end
  
  describe 'initialization' do
    before(:each) do
      @files = @files_class.new :some_name, :some_category, :some_type
    end
    it 'should initialize the name correctly' do
      @files.bundle_name.should == :some_name
    end
    it 'should initialize the name correctly' do
      @files.category_name.should == :some_category
    end
    it 'should initialize the name correctly' do
      @files.type_name.should == :some_type
    end
  end

end