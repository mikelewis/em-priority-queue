module EventMachine
  class PriorityQueue
    include Enumerable

    def initialize(&blk)
      blk ||= lambda { |x, y| (x <=> y) == 1 }
      @heap = Containers::Heap.new(&blk)
      @callbacks = []
    end

    def size
      @heap.size
    end

    def push(obj, pri)
      EM.schedule do
        @heap.push(pri, obj)
        @callbacks.shift.call(@heap.pop) until @heap.empty? || @callbacks.empty?
      end
    end

    def clear
      @heap.clear
    end

    def empty?
      @heap.empty?
    end

    def has_priority?(priority)
      @heap.has_key?(priority)
    end

    def next
      @heap.next
    end

    def pop(*a, &c)
      cb = EM::Callback(*a, &c)
      EM.schedule do
        if @heap.empty?
          @callbacks << cb
        else
          cb.call @heap.pop
        end
      end
      nil
    end

    def delete(pri)
      @heap.delete(pri)
    end

  end
end
