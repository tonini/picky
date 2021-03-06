require 'spec_helper'

describe Query::Combinator do
  
  context 'with option ignore_unassigned_tokens' do
    before(:each) do
      @category1 = stub :category1, :name => :category1
      @category2 = stub :category2, :name => :category2
      @category3 = stub :category3, :name => :category3
      @categories = [@category1, @category2, @category3]
    end
    context 'ignore_unassigned_tokens true' do
      before(:each) do
        @combinator = Query::Combinator.new @categories, :ignore_unassigned_tokens => true
      end
      it 'should return the right value' do
        @combinator.ignore_unassigned_tokens.should == true
      end
    end
    context 'ignore_unassigned_tokens false' do
      before(:each) do
        @combinator = Query::Combinator.new @categories, :ignore_unassigned_tokens => false
      end
      it 'should return the right value' do
        @combinator.ignore_unassigned_tokens.should == false
      end
    end
  end
  
  context "with real categories" do
    before(:each) do
      @type1     = stub :type1, :name => :some_type
      
      @category1 = Index::Category.new :some_name, @type1
      @category2 = Index::Category.new :some_name, @type1
      @category3 = Index::Category.new :some_name, @type1
      @categories = [@category1, @category2, @category3]
      
      @combinator = Query::Combinator.new @categories
    end
    describe "similar_possible_for" do
      before(:each) do
        @token = Query::Token.processed 'similar~'
      end
      it "returns possible categories" do
        @combinator.similar_possible_for(@token).should == []
      end
    end
  end
  
  context 'without options' do
    before(:each) do
      @category1 = stub :category1, :name => :category1
      @category2 = stub :category2, :name => :category2
      @category3 = stub :category3, :name => :category3
      @categories = [@category1, @category2, @category3]
      
      @combinator = Query::Combinator.new @categories
    end
    
    describe "possible_combinations_for" do
      before(:each) do
        @token = stub :token
      end
      context "with similar token" do
        before(:each) do
          @token.stub :similar? => true
        end
        it "calls the right method" do
          @combinator.should_receive(:similar_possible_for).once.with @token
          
          @combinator.possible_combinations_for @token
        end
      end
      context "with non-similar token" do
        before(:each) do
          @token.stub :similar? => false
        end
        it "calls the right method" do
          @combinator.should_receive(:possible_for).once.with @token
          
          @combinator.possible_combinations_for @token
        end
      end
    end
    
    describe 'possible_for' do
      context 'without preselected categories' do
        context 'user defined exists' do
          before(:each) do
            @token = stub :token, :user_defined_category_name => :category2
          end
          context 'combination exists' do
            before(:each) do
              @combination = stub :combination
              @category2.stub! :combination_for => @combination
            end
            it 'should return the right combinations' do
              @combinator.possible_for(@token).should == [@combination]
            end
          end
          context 'combination does not exist' do
            before(:each) do
              @category2.stub! :combination_for => nil
            end
            it 'should return the right combinations' do
              @combinator.possible_for(@token).should == []
            end
          end
        end
        context 'user defined does not exist' do

        end
      end
      context 'with preselected categories' do

      end
    end

    describe 'possible_categories' do
      context 'user defined exists' do
        before(:each) do
          @token = stub :token, :user_defined_category_name => :category2
        end
        it 'should return the right categories' do
          @combinator.possible_categories(@token).should == [@category2]
        end
      end
      context 'user defined does not exist' do
        before(:each) do
          @token = stub :token, :user_defined_category_name => nil
        end
        it 'should return all categories' do
          @combinator.possible_categories(@token).should == @categories
        end
      end
    end

    describe 'user_defined_categories' do
      context 'category exists' do
        before(:each) do
          @token = stub :token, :user_defined_category_name => :category2
        end
        it 'should return the right categories' do
          @combinator.user_defined_categories(@token).should == [@category2]
        end
      end
      context 'category does not exist' do
        before(:each) do
          @token = stub :token, :user_defined_category_name => :gnoergel
        end
        it 'should return nil' do
          @combinator.user_defined_categories(@token).should == nil
        end
      end
    end
  end
  
end