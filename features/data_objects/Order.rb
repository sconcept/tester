  require 'ffaker'

  class Order
    attr_accessor :name
    attr_accessor :address
    attr_accessor :email
    attr_accessor :payment
    attr_accessor :extras

    def initialize
      @name = FFaker::Name.first_name
      @address = FFaker::Address.street_address
      @email = FFaker::Internet.email
      @payment = "Credit card"
      @extras = {}
    end

  end
