# ActiveQueue 

ActiveQueue is a toolkit for queueing tasks and writing workers. It currently
only supports Starling, but additional gateways can be easily implemented.


## Getting Started

Install it:

    $ script/plugin install git://github.com/mojodna/active_queue.git

Define a Message:

    class EmailMessage < ActiveQueue::Message
      attributes :recipient, :subject, :body

      def process!
        DefaultMailer.deliver_email(recipient, subject, body)
      end
    end

Install and start starling:

    $ sudo gem install starling
    $ starling

Run the worker:

    $ script/queue_runner -q email

Put something in a queue:

    irb> EmailMessage.enqueue! \
           :recipient => "joe@example.com",
           :subject   => "Delays",
           :body      => "I might be late..."

---

Copyright (c) 2008 Blaine Cook and Seth Fitzsimmons, released under the MIT
license
