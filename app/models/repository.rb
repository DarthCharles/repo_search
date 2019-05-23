class Repository

  attr_accessor :author, :name, :url, :language, :stars, :updated_at

  def initialize(**attributes)
    attributes.each do |key, value|
      self.send(:"#{key}=", value)
    end
  end
end