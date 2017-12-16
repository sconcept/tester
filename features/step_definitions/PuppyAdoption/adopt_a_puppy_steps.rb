
  Given("The order {string} exists") do |order_alias|
    order = Order.new
    @test_data_world.add_order(order_alias, order)
  end

  Given(/^I am on the homepage$/) do
    visit_page HomePage
  end

  When ("I adopt a puppy providing {string}") do |order_alias|
    on(HomePage).select_a_puppy
    on(DogInformationPage).adopt_a_puppy
    on(CartPage).complete_adoption
    on(OrdersPage).complete_order(@test_data_world.fetch_order(order_alias))
  end

  Then(/^I should see the successful adoption message$/) do
    puts "Vars are: #{self.instance_variables}, #{$SK}"
    expect(@browser.text.include?("Recked")).to be true
  end
