class Company < ActiveRecord::Base
  
  attr_accessor :mandatory
  
  default :display_as_client => true, :featured => false

  scope :order_clients, (lambda do |*options| 
    order('companies.featured DESC, LOWER(companies.name) ASC')
  end)
  
  scope :clients, (lambda do 
    where(:display_as_client.eq => true).order_clients
  end)
    
  has_many :students
  
  has_many :representatives, :class_name => 'Student', 
  :conditions => { :parent_id => nil }
    
  has_many :payments, :through => :students
  
  validates :name, :length => { :in => 2..100 }, :uniqueness => true
   
end
