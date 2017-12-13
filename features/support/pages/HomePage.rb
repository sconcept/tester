class HomePage
   include PageObject

   page_url "http://puppies.herokuapp.com/"

   label(:notice_message, :id => 'notice')



   def select_a_puppy()
    
   end

end
