module ActiveQueue
  module Registry
    def registry
      @@registry ||= {}
      @@registry[self.to_s] ||= []
    end

  private

    def inherited(subclass)
      register(subclass)
    end

    def register(klass)
      @@registry ||= {}
      @@registry[self.to_s] ||= []
      @@registry[self.to_s] << klass unless @@registry[self.to_s].include?(klass)
    end
  end
end