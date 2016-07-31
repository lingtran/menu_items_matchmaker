class FileOperations
  def self.process_file(file)
    content = File.read(file)
    parse(content)
  end

  def self.parse(input)
    input.split("\n")
  end

  def self.write_to_file(content)
    writer = File.open("data/found_combos.txt", "w")
    writer.write(content)
    writer.close
  end
end
