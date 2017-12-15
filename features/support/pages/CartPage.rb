class CartPage
  include PageObject

  button(:complete_adoption_btn, :value => "Complete the Adoption")

  def complete_adoption(order_extras)
    complete_adoption_btn
  end

end
