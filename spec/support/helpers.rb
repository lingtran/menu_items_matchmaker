module Helpers
  def parse_data_file(file)
    File.read(file).split("\n")
  end

  def set_sample_target
    500
  end

  def set_items_and_prices
    [
      { "mixed fruit"       => 215 },
      { "golden omelette"   => 300 },
      { "tatter tots"       => 200 },
      { "orange juice"      => 100 },
      { "morning salad"     => 100 },
      { "wedged potatoes"   => 200 },
      { "oatmeal"           => 600 }
    ]
  end

  def set_addtl_items_and_prices
    [
      { "fries"               => 400 },
      { "beer"                => 400 },
      { "pumpkin curry pasta" => 1000 },
      { "pomegranate juice"   => 600 }
    ]
  end

  def set_another_target
    1505
  end

  def set_more_items_and_prices
    [
      { "mixed fruit"           => 215 },
      { "french fries"          => 275 },
      { "side salad"            => 335 },
      { "hot wings"             => 355 },
      { "mozzarella sticks"     => 420 },
      { "sampler plate"         => 580 },
      { "larger sampler plate"  => 925 }
    ]
  end

  def sad_result
    return "\tUnfortunately, there is no combination of dishes that sum to the target price."
  end

  def happy_result
    [
      [{ "tatter tots"=>200 }, { "golden omelette"=>300 }],
      [{ "orange juice"=>100 }, { "morning salad"=>100 }, { "golden omelette"=>300 }]
    ]
  end
end
