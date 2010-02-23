# Monkey patching feedzirra to support defining multiple elements on existing Entry classes
module Feedzirra
  class Feed
    def self.add_common_feed_entry_elements(element_tag, options = {})
      feed_classes.map{|k| eval("#{k}Entry") }.each do |klass|
        klass.send(:elements, element_tag, options)
      end
    end
  end
end