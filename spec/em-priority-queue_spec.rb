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

    it "should create a fifo priority queue if specified" do
      fifo_queue = EM::PriorityQueue.new(:fifo => true)
      responses = []
      EM.run do
        fifo_queue.push("Checking1", 20)
        Delorean.jump 30
        fifo_queue.push("Other1", 16)
        Delorean.jump 30
        fifo_queue.push("Other2", 18)
        Delorean.jump 30
        fifo_queue.push("Checking2", 20)
        Delorean.jump 30
        fifo_queue.push("Checking3", 20)
        Delorean.jump 30
        fifo_queue.push("Checking4", 20)
        Delorean.jump 30
        fifo_queue.push("Checking5", 20)
        Delorean.jump 30
        fifo_queue.push("Checking6", 20)
        Delorean.jump 30
        fifo_queue.push("Other3", 33)
        Delorean.jump 30
        fifo_queue.push("Checking7", 20)
        Delorean.jump 30
        fifo_queue.push("Checking8", 20)
        Delorean.jump 30

        11.times do
          fifo_queue.pop do |e|
            responses << e
            EM.stop if responses.size == 4
          end
        end

      end

      responses.first(5).should == ["Other3", "Checking1", "Checking2", "Checking3", "Checking4"]

    end
    it "should create a fifo priority queue if specified - custom ordering schema" do
      fifo_queue = EM::PriorityQueue.new(:fifo => true) {|x,y| x < y}
      responses = []
      EM.run do
        fifo_queue.push("Checking1", 20)
        Delorean.jump 30
        fifo_queue.push("Other1", 16)
        Delorean.jump 30
        fifo_queue.push("Other2", 18)
        Delorean.jump 30
        fifo_queue.push("Checking2", 20)
        Delorean.jump 30
        fifo_queue.push("Checking3", 20)
        Delorean.jump 30
        fifo_queue.push("Checking4", 20)
        Delorean.jump 30
        fifo_queue.push("Checking5", 20)
        Delorean.jump 30
        fifo_queue.push("Checking6", 20)
        Delorean.jump 30
        fifo_queue.push("Other3", 33)
        Delorean.jump 30
        fifo_queue.push("Checking7", 20)
        Delorean.jump 30
        fifo_queue.push("Checking8", 20)
        Delorean.jump 30

        11.times do
          fifo_queue.pop do |e|
            responses << e
            EM.stop if responses.size == 4
          end
        end

      end

      responses.first(5).should == ["Other1", "Other2", "Checking1", "Checking2", "Checking3"]

    end


    it "should give elements in the order of their priority - custom ordering schema" do
      @q = EM::PriorityQueue.new {|x,y| x < y}
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

      responses[0].should == "Tim"
      responses[1].should == "Mike"
      responses[2].should == "Alex"
      responses[3].should == "Bob"
    end
  end

  context "README demos" do
    it "should run the first fifo example" do
          @q = EM::PriorityQueue.new(:fifo => true)

    responses = []
      EM.run do


        @q.push("Mike", 20)
        @q.push("Alex", 21)
        @q.push("Bob", 20)
        @q.push("Tim", 18)
        @q.push("Carol", 20)

        5.times do
          @q.pop do |e|
            responses << e
            EM.stop if responses.size == 5
          end
        end
      end

      responses[0].should == "Alex"
      responses[1].should == "Mike"
      responses[2].should == "Bob"
      responses[3].should == "Carol"
      responses[4].should ==  "Tim"
    end

    it "should run the second fifo example" do
      @q = EM::PriorityQueue.new(:fifo => true) {|x,y| x < y}

      responses = []
      EM.run do


        @q.push("Mike", 20)
        @q.push("Alex", 21)
        @q.push("Bob", 20)
        @q.push("Tim", 18)
        @q.push("Carol", 20)

        5.times do
          @q.pop do |e|
            responses << e
            EM.stop if responses.size == 5
          end
        end
      end

      responses[0].should == "Tim" # Tim
      responses[1].should == "Mike" # Mike
      responses[2].should == "Bob" # Bob
      responses[3].should == "Carol" # Carol
      responses[4].should == "Alex" # Alex

    end
  end
end
