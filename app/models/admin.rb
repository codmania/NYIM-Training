class Admin < User

  has_many :submissions, :class_name => 'Signup', :foreign_key => :created_by_id
  
  has_many :payments, :foreign_key => :user_id 
    
  def shopping_cart(student_id=nil)
    # student id constraint is not ignored if nil 
    # this gives back only admin-submitted signups for student
    #student_id ? submissions.shopping_cart.student_id_equals(student_id) : submissions.shopping_cart
    # this gives all signups for student
    student_id && student_id != id ? Signup.shopping_cart(student_id).where(:submitter_id => student_id) : submissions.shopping_cart
  end

end