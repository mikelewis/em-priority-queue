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


  

  To see all examples/cases, see the spec file.
    

