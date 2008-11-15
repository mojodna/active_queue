module ActiveQueue

  class EmptyQueueError < StandardError; end
  class InvalidMessageError < StandardError; end

  module QueueHelper
    def self.included(klass)
      klass.extend ActiveQueue::QueueHelper::ClassMethods
    end

    module ClassMethods
      def process!
        msg = dequeue
        raise ActiveQueue::EmptyQueueError if msg.nil?
        raise ActiveQueue::InvalidMessageError unless msg.respond_to?(:process!)
        msg.process!
      end
    end
  end
end
