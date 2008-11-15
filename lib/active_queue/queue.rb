require 'active_queue/queue_helper'

module ActiveQueue
  class Queue
    extend  ActiveQueue::Registry
    include ActiveQueue::QueueHelper

    class << self
      def available_queues
        registry.sort { |a,b| a.to_s <=> b.to_s }.collect do |queue|
          queue.queue_name
        end * "\n"
      end

      def enqueue(msg)
        gateway.enqueue(queue_name, msg) unless msg.nil?
      end

      def dequeue
        gateway.dequeue(queue_name)
      end

      # Set the default gateway for all queues
      def default_gateway=(gateway)
        @@gateway = gateway
      end

      def queue_name=(queue_name)
        @queue_name = queue_name
      end

      def registry
        # discover queues from the Message registry and register them
        # this is necessary for dynamically defined Queues to be registered properly
        ActiveQueue::Message.registry.each do |message|
          register(message.queue)
        end

        super
      end

      def reset!
        gateway.reset!(queue_name)
      end

      def size
        gateway.size(queue_name)
      end

    protected

      def gateway
        return @@gateway if @@gateway

        require 'active_queue/gateways/local'
        @@gateway = ActiveQueue::LocalGateway.new
      end

      def queue_name
        queue_name ||= self.to_s.underscore.gsub(/_queue$/, '')
      end

      def empty?
        gateway.empty?(queue_name)
      end
    end
  end
end
