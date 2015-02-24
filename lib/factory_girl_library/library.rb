module FactoryGirlLibrary
  class Library
    include Singleton

    def initialize
      @library = {}.with_indifferent_access
      @registration_queue = []
    end

    def register name, object
      @library[name] = object
      @registration_queue.push(object)
    end

    def registered? name
      @library.has_key?(name)
    end

    def get name, opts = {}
      @library[name].tap do |object|
        update(object, opts)
      end
    end

    def reload object
      object.reload if @library.value?(object) and object.respond_to?(:reload)
    end

    def clear
      @library.clear

      while object = @registration_queue.pop
        object.destroy
      end
    end

    private

    def update obj, opts
      if obj && opts.present?
        opts.each do |key, value|
          obj.send("#{key}=", value)
        end

        obj.save!
      end

      obj
    end
    
    class << self
      delegate :register, :registered?, :reload, :get, :clear, to: :instance
    end
  end
end