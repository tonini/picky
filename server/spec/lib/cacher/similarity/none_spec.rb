# encoding: utf-8
#
require 'spec_helper'

describe Cacher::Similarity::None do

  before(:each) do
    @similarity = Cacher::Similarity::None.new
  end

  describe 'encode' do
    it 'should always return nil' do
      @similarity.encoded(:whatever).should == nil
    end
  end

  describe 'generate_from' do
    it 'should return an empty hash, always' do
      @similarity.generate_from(:anything).should == {}
    end
  end

end