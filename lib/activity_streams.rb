require 'rubygems'
require 'feedzirra'
require 'json'
require 'hashie'

require 'activity_streams/feedzirra_patches'
require 'activity_streams/common_fields'
require 'activity_streams/portable_contact'

module ActivityStreams
  class Object
    include CommonFields
  end
  
  class Actor
    include CommonFields
  end
  
  class Target
    include CommonFields
  end
  
  class Context
    include CommonFields
  end
  
  class Feed < Hashie::Dash
    attr_accessor :entries
    attr_accessor :raw_structure
    
    # Creates a new Feed instance by parsing the XML string as an Atom feed with ActivityStreams
    # extensions.
    #
    # @param [String] xml string representing an Atom feed with ActivityStreams extensions
    # @return [Feed] a new instance filled with the data found on the XML string
    def self.from_xml(xml)
      unless defined?(@@_feedzirra_init)
        @@_feedzirra_init = true
        Feedzirra::Feed.add_common_feed_entry_elements("activity:verb", :as => :activity_verbs)
        Feedzirra::Feed.add_common_feed_entry_elements("activity:object", :as => :activity_objects, :class => ActivityStreams::Object)
        Feedzirra::Feed.add_common_feed_entry_element("activity:actor", :as => :activity_actor, :class => ActivityStreams::Actor)
        Feedzirra::Feed.add_common_feed_entry_element("activity:target", :as => :activity_target, :class => ActivityStreams::Target)
        Feedzirra::Feed.add_common_feed_entry_element("activity:context", :as => :activity_context, :class => ActivityStreams::Context)
      end

      res = Feed.new
      res.raw_structure = Feedzirra::Feed.parse(xml)
      res.entries = []
      
      res.raw_structure.entries.each do |entry|
        e = Hashie::Mash.new
        
        # verbs
        e.verbs = []
        entry.activity_verbs.each do |verb|
          e.verbs << verb
        end
        
        # actor, target, context
        [:actor, :target, :context].each do |area|
          e[:actor]   ||= Hashie::Mash.new
          e[:target]  ||= Hashie::Mash.new
          e[:context] ||= Hashie::Hash.new
          
          [:id, :links, :object_types, :title, :author, :content].each do |attr|
            unless entry.send("activity_#{area}").nil?
              e.send(:[], area).send(:[]=, attr, entry.send("activity_#{area}").send(attr))
            end
          end
        end
        
        # objects
        e.objects = []
        entry.activity_objects.each do |object|
          o = Hashie::Mash.new
          [:id, :links, :object_types, :title, :author, :content].each do |attr|
            o[attr] = object.send(attr)
          end
          e.objects << o
        end
        
        res.entries << e
      end
      
      return res
    end
    
    # Creates a new Feed instance by parsing the JSON string a list of JSON encoded ActivityStreams
    #
    # @param [String] json string representing a list of JSON encoded ActivityStreams
    # @return [Feed] a new instance filled with the data found on the JSON string
    def self.from_json(json)
      res = Feed.new
      res.raw_structure = JSON.parse(json)
      res.entries = []
      
      res.raw_structure.map { |x| x['activity'] }.delete_if(&:nil?).each do |entry|
        e = Hashie::Mash.new
        
        # verbs
        e.verbs = []
        entry['verbs'] && entry['verbs'].each do |verb|
          e.verbs << verb
        end
        
        # actor, target, context
        [:actor, :target, :context].each do |area|
          e[:actor]   ||= Hashie::Mash.new
          e[:target]  ||= Hashie::Mash.new
          e[:context] ||= Hashie::Hash.new
          
          [:id, :links, :object_types, :title, :author, :content].each do |attr|
            unless entry.send(:[], area.to_s).nil?
              json_attr = attr.to_s.gsub(/\_(\w)/) { $1.upcase }
              e.send(:[], area).send(:[]=, attr, entry.send(:[], area.to_s).send(:[], json_attr))
            end
          end
        end
        
        # objects
        e.objects = []
        entry['objects'] && entry['objects'].each do |object|
          o = Hashie::Mash.new
          [:id, :links, :object_types, :title, :author, :content].each do |attr|
            json_attr = attr.to_s.gsub(/\_(\w)/) { $1.upcase }
            o[attr] = object.send(:[], json_attr)
          end
          e.objects << o
        end
        
        res.entries << e
      end
      
      return res
    end
  end
end
