Given(/^I am on the adopt puppy homepage$/) do
    visit_page HomePage
end

When (/^I adopt a puppy$/) do
   on(HomePage).select_a_puppy
end
