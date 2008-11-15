module ActiveQueue
  class StarlingGateway < Gateway
    def initialize(servers)
      @starling = MemCache.new(servers)
    end

    def enqueue(queue, value)
      @starling.set(queue, value)
    end

    def dequeue(queue)
      @starling.get(queue)
    end
  end
end
