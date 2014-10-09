class ActiveRecord::Base
  def to_test_yaml(exported_objects=[])
    return if exported_objects.include?(self)

    if self.new_record? || self.changed?
      raise "Can't export unsaved post to fixtures"
    end
    if self.invalid?
      raise "Post is invalid and shouldn't be exported"
    end

    if Rails.env == "test"
      file_name = "post_tests"
    else
      file_name = self.class.table_name
    end

    yaml_file = Rails.root + "test/fixtures/#{file_name}.yml"

    if File.exists?(yaml_file)
      yaml_data = File.read(yaml_file)
      if yaml_data.match(/ id: #{id}/) || yaml_data.match(/ id: "#{id}"/)
        puts "Warning skipped: #{self.class.name}:#{id}\nAlready found " +
          "in: #{yaml_file}"
        return
      end
    end

    exported_objects << self
    self.reflections.keys.each do |assoc|
      value = self.send(assoc)
      if value.is_a?(ActiveRecord::Base)
        value.to_test_yaml(exported_objects)
      else
        value.to_a.each{|v| v.to_test_yaml(exported_objects)}
      end
    end

    yaml_data = self.to_yaml
    if File.exists?(yaml_file)
      yaml_data.sub!(/--- !ruby\/object.*\n/, "")
    end
    id = self.respond_to?(:id) ? self.id : Time.now
    yaml_data.sub!(/attributes:/, "#{file_name}_#{id}:")

    File.open(yaml_file, "a") {|f| f.puts yaml_data }
  end
end
