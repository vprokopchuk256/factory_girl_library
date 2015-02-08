module DB
  def db
    ActiveRecord::Base.connection
  end
end