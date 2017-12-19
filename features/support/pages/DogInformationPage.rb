class DogInformationPage
  include PageObject

  button(:adopt_me_btn, value: 'Adopt Me!')

  # select the adopt button when viewing the puppy
  def adopt_a_puppy
    adopt_me_btn
  end
end
