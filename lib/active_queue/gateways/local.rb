module ActiveQueue
  class LocalGateway < Gateway
    def initialize(opts = {})
      @queues = {}
    end

    def queue(queue_name)
      @queues[queue_name] ||= ::Queue.new
    end

    def enqueue(queue_name, value)
      queue(queue_name).push(value)
    end

    def dequeue(queue_name)
      queue(queue_name).pop(true) unless empty?(queue_name)
    end

    def reset!(queue_name)
      queue(queue_name).clear
    end

    def size(queue_name)
      queue(queue_name).size
    end

    def empty?(queue_name)
      queue(queue_name).size == 0
    end
  end
end
