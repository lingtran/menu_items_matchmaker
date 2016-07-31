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
    result.map { |combo| "Combo: #{format_combo(combo)}" }.join("\n")
  end

  def format_combo(combo)
    combo.map { |item| "#{item.keys.first}, #{item.values.first}"}.join("; ")
  end
end
