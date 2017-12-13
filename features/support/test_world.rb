class Test_World
  def initialize
    @puppies = {}
  end

  def clean
    @puppies.clear
  end

  def add_user(puppy_alias, puppy)
    @puppies[puppy_alias] = puppy
  end

  def get_user(puppy_alias)
    @puppies[puppy_alias]
  end
end
