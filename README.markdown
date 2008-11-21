# ActiveQueue 

ActiveQueue is a toolkit for queueing tasks and writing workers. It currently
only supports Starling, but additional gateways can be easily implemented.


## Getting Started

Install it:

    $ script/plugin install git://github.com/mojodna/active_queue.git
    $ sudo gem install fiveruns-memcache-client -s http://gems.github.com

Define a Message:

    require 'active_queue'
    class EmailMessage < ActiveQueue::Message
      attributes :recipient, :subject, :body

      def process!
        DefaultMailer.deliver_email(recipient, subject, body)
      end
    end

Configure ActiveQueue (in a Rails app, this goes in
`config/initializers/active_queue.rb`):

    config_file = File.join(RAILS_ROOT, 'config', 'active_queue.yml')
    config = YAML.load(ERB.new(File.read(config_file)).result)[RAILS_ENV]

    require "active_queue/gateways/#{config['gateway']}"

    gateway_class_name = "#{config['gateway']}_gateway".camelize
    gateway_class      = ActiveQueue.const_get(gateway_class_name)

    ActiveQueue::Queue.default_gateway = gateway_class.new(config['servers'])

`config/active_queue.yml`:

    development:
      gateway: starling
      servers:
        - localhost:22122
    test:
      gateway: local
    production:
      gateway: local

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
