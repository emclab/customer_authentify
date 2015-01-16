require "customer_authentify/engine"

module CustomerAuthentify
  mattr_accessor :customer_class, :project_class
  
  def self.customer_class
    @@customer_class.constantize
  end
  
  def self.project_class
    @@project_class.constantize
  end
end
