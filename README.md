EventMachine Priority Queue
=============

##Install
    [sudo] gem install em-priority-queue

##Usage

  **Basic**

    @q = EM::PriorityQueue.new

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

      responses[0] # Bob
      responses[1] # Alex
      responses[2] # Mike
      responses[3] # Tim

  **Custom Priority**

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

      responses[0] # Tim
      responses[1] # Mike
      responses[2] # Alex
      responses[3] # Bob


  **FIFO (first in, first out)**

  When values have the same priority, you may want to use FIFO to prioritize even more. This way, em-priority-queue will pop the items in the order that they were pushed.

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

      responses[0] # Alex
      responses[1] # Mike
      responses[2] # Bob
      responses[3] # Carol
      responses[4] # Tim

  **FIFO with custom priority**

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

      responses[0] # Tim
      responses[1] # Mike
      responses[2] # Bob
      responses[3] # Carol
      responses[4] # Alex





  To see all examples/cases, see the spec file.


##License

Copyright (c) 2011 Mike Lewis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
