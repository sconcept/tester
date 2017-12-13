Before do |scenario|

end

After('@reset_recurring_donations') do
  reset_recurring_donations_settings(@recurring_donations_settings)
end

After do |scenario|

end
