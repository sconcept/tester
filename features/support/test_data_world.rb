class Test_Data_World
  def initialize
    @orders = {}
  end

  def reset
    @orders.clear
  end

  def add_order(order_alias, order)
    @orders[order_alias] = order
  end

  def fetch_order(order_alias)
    @orders[order_alias]
  end
end
