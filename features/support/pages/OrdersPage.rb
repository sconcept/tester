class OrdersPage
  include PageObject

    text_field(:order_name, :id => "order_name")
    textarea(:order_address, :id => "order_address")
    text_field(:order_mail, :id => "order_email")
    select_list(:order_payment_type, :id => "order_pay_type")
    button(:submit_order_btn, :value => "Place Order")

 def complete_order(order)
   self.order_name = order.name
   self.order_address = order.address
   self.order_mail = order.email
   self.order_payment_type = order.payment
   self.submit_order_btn
 end
end
