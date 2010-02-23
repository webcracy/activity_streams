module ActivityStreams
  class PortableContact
    include SAXMachine
    element :"poco:givenName", :as => :given_name
    element :"poco:familyName", :as => :family_name
  end
end