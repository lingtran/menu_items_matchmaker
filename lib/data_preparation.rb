class DataPreparation
  def initialize
  end

  def assign_target_price(input)
    convert_to_float(input.first)
  end

  def split_data(input)
    input[1..-1].map { |item| item.split(',') }
  end

  def format_split_data(input)
    split_data(input).map { |item| [ item[0], convert_to_float(item[1]) ] }
  end

  def assign_items_with_prices(input)
    format_split_data(input).map { |item| Hash[*item] }
  end

  def convert_to_float(element)
    element.gsub(/[^\d\.]/, '').to_f
  end
end
