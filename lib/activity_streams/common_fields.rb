module ActivityStreams
  module CommonFields
    def self.included(klass)
      klass.class_eval do
        include SAXMachine
        include Feedzirra::FeedEntryUtilities
        
        elements :"activity:object-type", :as => :object_types
        element :id
        element :title, :with => {:type => "text"}
        element :content
        elements :link, :as => :links, :value => :href
        element :"poco:name", :as => :poco_name, :class => ActivityStreams::PortableContact
        element :name, :as => :author
      end
    end
  end
end