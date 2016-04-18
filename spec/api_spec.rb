require_relative '../api'
require 'spec_helper'
require_relative '../schema'
require_relative '../db'

describe Api do
  before :each do
    @schema = Schema.new
    @schema.seed_data
    @db = DB.new
    @api = Api.new @db

  end

  describe "#initialize" do
    it "takes no parameter and returns an Api object" do
        expect(@api).to be_a Api
    end
  end

  describe "#generate_keys" do
    context "with no parameters" do
      it "creates 100 random keys" do
        expect(@api.generate_keys).to eq(100)
      end
    end

    context "with a parameter" do
      it "creates keys equal to the number given in the argument" do
        expect(@api.generate_keys(11)).to eq(11)
      end
    end

    context "with a negative parameter" do
      it "Should raise an error complaining that the number should be greater than 1" do
        expect {@api.generate_keys(-1)}.to raise_error('The number should be grater than 1')
      end
    end

    context "with argument value as 0" do
      it "Should raise an error complaining that the number shoudld be greater than 1" do
        expect {@api.generate_keys(0)}.to raise_error('The number should be grater than 1')
      end
    end

    context "with a string parameter that whose .to_i value is zero" do
      it "Should raise an error complaining that the number shoudld be greater than 1" do
        expect {@api.generate_keys("shhsg")}.to raise_error('The number should be grater than 1')
      end
    end

    context "with an invalid data structure as an argument" do
      it "should raise an error complaining that the arguemnt should be an integer" do
        expect {@api.generate_keys(['anan'])}.to raise_error('The argument should be an integer')
      end
    end
  end

  describe "#allocate_key" do

    context "takes no parameter" do
      it "returns a random key" do
        key = @api.allocate_key
        expect(@api.allocate_key).to be_truthy
      end
    end

    context "when given a paramenter" do
      it "raises an Argument Error" do
        expect {@api.allocate_key('some arg')}.to raise_error(ArgumentError)  
      end
    end
    
    context "When all keys are blocked" do
      it "Gives key as nil" do
        @schema.set_all_blocked
        expect(@api.allocate_key).to be nil
      end
    end
    
    context "when one key is available" do
      it "Should give back that key and the next call should give back nil" do
        @schema.set_all_blocked
        @schema.add_one #inserts a hardcoded value
        expect(@api.allocate_key).to eq '12920' #harcoded value 
        expect(@api.allocate_key).to be nil
      end
    end
  end

  describe "#unblock_key" do

    context "when argument is given" do
      it "unblocks the key passed in the argument" do
        expect(@api.unblock_key(52)).to be
      end
    end

    context "when no argument is given" do
      it "raises an ArgumentError" do
        expect {@api.unblock_key}.to raise_error(ArgumentError)
      end
    end

    context "when invalid key is given" do
      it "raises an excpetion complaining about non-existing key" do
        expect {@api.unblock_key(166)}.to raise_error('Key not found')
      end
    end
  end

  describe "#delete_key" do

    context "when argument is given" do
      it "deletes the key passed in the argument" do
        expect(@api.delete_key(6)).to be
      end
    end

    context "when no argument is given" do
      it "raises an ArgumentError" do
        expect {@api.delete_key}.to raise_error(ArgumentError)
      end
    end

    context "when invalid key is given" do
      it "raises an excpetion complaining about non-existing key" do
        expect {@api.delete_key(166)}.to raise_error('Key not found')
      end
    end
  end

  describe "#keep_alive" do

    context "when argument is given" do
      it "extends the keep alive time of the key" do
        expect(@api.keep_alive(6)).to be
      end
    end

    context "when no argument is given" do
      it "raises an ArgumentError" do
        expect {@api.keep_alive}.to raise_error(ArgumentError)
      end
    end

    context "when invalid key is given" do
      it "raises an excpetion complaining about non-existing key" do
        expect {@api.keep_alive(166)}.to raise_error('Key not found')
      end
    end
  end
end
