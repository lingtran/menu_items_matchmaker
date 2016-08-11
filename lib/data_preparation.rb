class DataPreparation
  def initialize
  end

  def assign_target_price(input)
    @_target = convert_to_integer(input.first)
  end

  def split_data(input)
    input[1..-1].map { |item| item.split(',') }
  end


  def convert_to_float(element)
    element.gsub(/[^\d\.]/, '').to_f
  end

  def convert_to_integer(element)
    (convert_to_float(element) * 100).to_i
  end

  def format_split_data(input)
    split_data(input).map { |item| [ item[0], convert_to_integer(item[1]) ] }
  end

  def assign_items_with_prices(input)
    @_items_prices = format_split_data(input).map { |item| Hash[*item] }
  end


  private
    def target
      @_target
    end

    def items_prices
      @_items_prices
    end
end
