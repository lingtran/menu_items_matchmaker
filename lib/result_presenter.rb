class ResultPresenter
  attr_reader :result,
              :formatted_result

  def initialize(result)
    @result = result
  end

  def determine_format
    if result.class == Array
      @formatted_result = happy_path
    else
      @formatted_result = result
    end
  end

  def happy_path
    result.map { |combo| "\tCombo: #{format_combo(combo)}" }.join("\n")
  end

  def format_combo(combo)
    combo.map do |item|
      "#{format_quantity(item)}, #{format_item_name(item)} (#{format_item_price(item)})"
    end.join("; ")
  end

  def format_quantity(item)
    item.keys.first
  end

  def format_item_name(item)
    item.values.first.keys.first
  end

  def format_item_price(item)
    (item.values.first.values.first/100).to_f
  end
end
