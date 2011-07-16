require 'spec_helper'

describe EventMachine::PriorityQueue do

  before do
    @q = EM::PriorityQueue.new
  end

  context "Reg. Queue" do
    it "should return 0 for size and be empty" do
      @q.size.should == 0
      @q.empty?.should == true
    end

    it "should should push things onto the queue" do
      EM.run do
        5.times do |i|
          @q.push(i, 1)
        end
        EM.stop
      end

      @q.size.should == 5
    end

    it "should pop elements after adding them" do
      responses = []
      EM.run do
        5.times do |i|
          @q.push(i, 1)
        end

        5.times do
          @q.pop do |e|
            responses << e
            EM.stop if @q.empty?
          end
        end
      end

      responses.length.should == 5
      [0,1,2,3,4].each do |n|
        responses.should include(n)
      end
    end

    it "should pop elements if there are callbacks waiting for pushes" do
      responses = []
      EM.run do
        3.times do
          @q.pop do |e|
            responses << e
            EM.stop if responses.size == 3
          end
        end

        5.times do |n|
          @q.push(n, 1)
        end
      end
      responses.length.should == 3
      [0,1,2].each do |n|
        responses.should include(n)
      end
    end
  end

  context "Priority Queue" do
    it "should give elements in the order of their priority" do
      responses = []
      EM.run do


        @q.push("Mike", 20)
        @q.push("Alex", 21)
        @q.push("Bob", 22)
        @q.push("Tim", 18)

        4.times do
        @q.pop do |e|
          responses << e
          EM.stop if responses.size == 4
        end
        end
      end

      responses[0].should == "Bob"
      responses[1].should == "Alex"
      responses[2].should == "Mike"
      responses[3].should == "Tim"

    end
  end
end
