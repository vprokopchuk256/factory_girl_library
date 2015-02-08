module FactoryGirlLibrary
  class Library
    include Singleton

    def initialize
      @library = {}.with_indifferent_access
      @connection = ActiveRecord::Base.connection.clone
    end
   
    def create name, opts 
      unless @library[name]
        Thread.new{ @library[name] = ::FactoryGirl.create(name) }.join
      end

      update(@library[name], opts)
    end

    def clear
      @library.clear
    end

    def reload(obj)
      if name = @library.key(obj) and obj.respond_to?(:reload)
        @library[name] = obj.reload
      end
    end

    private


    def update obj, opts
      if opts.present?
        opts.each do |key, value|
          obj.send("#{key}=", value)
        end
      end

      obj.save!
      obj
    end
    
    class << self
      delegate :create, :clear, :reload, to: :instance
    end
  end
end