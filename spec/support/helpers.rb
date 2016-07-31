module Helpers
  def parse_data_file(file)
    File.read(file).split("\n")
  end

  def set_sample_target
    5.00
  end

  def set_items_and_prices
    [
      { "mixed fruit"       => 2.15 },
      { "golden omelette"   => 3.00 },
      { "tatter tots"       => 2.00 },
      { "orange juice"      => 1.00 },
      { "morning salad"     => 1.00 },
      { "wedged potatoes"   => 2.00 },
      { "oatmeal"           => 6.00 }
    ]
  end

  def set_addtl_items_and_prices
    [
      { "fries"               => 4.00 },
      { "beer"                => 4.00 },
      { "pumpkin curry pasta" => 10.00 },
      { "pomegranate juice"   => 6.00 }
    ]
  end

  def set_another_target
    15.05
  end

  def set_more_items_and_prices
    [
      { "mixed fruit"           => 2.15 },
      { "french fries"          => 2.75 },
      { "side salad"            => 3.35 },
      { "hot wings"             => 3.55 },
      { "mozzarella sticks"     => 4.20 },
      { "sampler plate"         => 5.80 },
      { "larger sampler plate"  => 9.25 }
    ]
  end

  def sad_result
    return "\tUnfortunately, there is no combination of dishes that sum to the target price."
  end

  def happy_result
    [
      [{ "tatter tots"=>2.0 }, { "golden omelette"=>3.0 }],
      [{ "orange juice"=>1.0 }, { "morning salad"=>1.0 }, { "golden omelette"=>3.0 }]
    ]
  end
end
