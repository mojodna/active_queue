module ActiveQueue
  class Message
    extend ActiveQueue::Registry

    class << self
      def attributes(*args)
        valid_attributes << args
        valid_attributes.flatten!
        valid_attributes.uniq!
        attr_accessor *args
      end

      def enqueue!(object)
        msg = new(object)
        msg.enqueue!
        msg
      end

      def dequeue!
        queue.dequeue
      end

      def queue(*args)
        if args.any?
          @queue = args.shift
        end

        return @queue if @queue

        # We don't have a queue defined for this message class, so build one
        # using some sensible defaults.
        queue_class = "#{self.to_s.gsub("Message", "")}Queue"

        Object.const_set(queue_class, Class.new(Queue))
        @queue = Object.const_get(queue_class)
        @queue.queue_name = self.to_s.underscore

        @queue
      end

      def valid_attributes
        @valid_attributes ||= []
      end

      def process!
        message = dequeue!
        message.process! if message
      end
    end

    def initialize(object)
      extract_attributes_from object
    end

    def enqueue!
      self.class.queue.enqueue(to_queue_object)
    end

    def process!
      raise NotImplementedError, "subclasses of ActiveQueue::Message must implement process!"
    end

  protected

    def extract_attributes_from(object)
      self.class.valid_attributes.each do |attribute|
        if object.respond_to?(attribute)
          self.send("#{attribute}=", object.send(attribute))
        elsif object.respond_to?(:has_key?) && object.has_key?(attribute)
          self.send("#{attribute}=", object[attribute])
        end
      end
    end

    def to_queue_object
      self
    end
  end
end
