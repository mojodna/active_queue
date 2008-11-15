module ActiveQueue
  class Gateway
    extend ActiveQueue::Registry

    def enqueue(queue, msg)
      raise NotImplementedError, "subclasses of ActiveQueue::Gateway must implement enqueue"
    end

    def dequeue(queue)
      raise NotImplementedError, "subclasses of ActiveQueue::Gateway must implement dequeue"
    end

    def reset!(queue)
      raise NotImplementedError, "subclasses of ActiveQueue::Gateway must implement reset!"
    end

    def empty?(queue)
      raise NotImplementedError, "subclass of ActiveQueue::Gateway must implement empty?"
    end
  end
end
