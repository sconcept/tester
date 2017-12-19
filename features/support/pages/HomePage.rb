require 'watir'
class HomePage
  include PageObject

  page_url 'http://puppies.herokuapp.com/'

  label(:notice_message, id: 'notice')
  button(:view_details_btn, value: 'View Details', index: 1)

  def select_a_puppy
    view_details_btn
  end
end
