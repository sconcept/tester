class HomePage
   include PageObject

   page_url "https://www.google.co.uk"

   text_field(:search_input, :id => 'lst-ib')
   button(:search_button, :name => 'btnK')

   def execute_search(text)
     self.search_input = text
     send_keys :enter
   end

end
