require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActivityStreams", "twitter" do
  before :all do
    @twitter_xml = IO.read(File.expand_path(File.dirname(__FILE__) + "/twitter.xml"))
    @feed = ActivityStreams::Feed.from_xml(@twitter_xml)
  end
  
  it "should parse twitter example" do
    @feed.should_not be_nil
  end
  
  it "should have 20 entries" do
    @feed.entries.size.should == 20
  end
  
  it "should have id, title and published on the first entry" do
    entry = @feed.entries.first
    entry.id.should == "http://twitter.com/rubenfonseca/statuses/9108531677"
    entry.title.should == "rubenfonseca: @microft humm what about dropbox?"
    entry.published.class.should == Time
  end
  
  it "should have a list of activity:verb on the first entry" do
    verbs = @feed.entries.first.verbs
    verbs.class.should == Array
    verbs.size.should == 1
    verbs.first.should =~ /post/
  end
  
  it "should have a list of activity:object on the first entry" do
    objects = @feed.entries.first.objects
    objects.class.should == Array
    objects.size.should == 1
  end
  
  it "should parse a proper activity:object" do
    object = @feed.entries.first.objects.first
    object.object_types.size.should == 1
    object.object_types.first.should =~ /note/
    object.content.should == "rubenfonseca: @microft humm what about dropbox?"
    
    object.links.size.should == 1
    object.links.first.should == "http://twitter.com/rubenfonseca/statuses/9108531677"
  end
  
  it "should have an activity:actor on the first entry" do
    object = @feed.entries.first.actor
    object.should_not be_nil
  end
  
  it "should parse a proper activity:actor" do
    object = @feed.entries.first.actor
    object.object_types.size.should == 1
    object.object_types.first.should =~ /person/
    object.title.should == "rubenfonseca"
  end
end

describe "ActivityStreams", "lastfm" do
  before :all do
    @lastfm_xml = IO.read(File.expand_path(File.dirname(__FILE__) + "/lastfm.xml"))
    @feed = ActivityStreams::Feed.from_xml(@lastfm_xml)
  end
  
  it "should parse lastfm example" do
    @feed.should_not be_nil
  end
  
  it "should have 10 entries" do
    @feed.entries.size.should == 10
  end
  
  it "should have tite, id and published on each entry" do
    @feed.entries.first.title.should == "Alicia Keys – Sure Looks Good To Me"
    @feed.entries.first.id.should == "http://www.last.fm/user/krani1#1266166889"
    @feed.entries.first.published.class.should == Time
  end
  
  it "should have a list of activity:verb on the first entry" do
    verbs = @feed.entries.first.verbs
    verbs.class.should == Array
    verbs.size.should == 1
    verbs.first.should =~ /play/
  end
  
  it "should have a list of activity:object on the first entry" do
    objects = @feed.entries.first.objects
    objects.class.should == Array
    objects.size.should == 1
  end
  
  it "should parse a proper activity:object" do
    object = @feed.entries.first.objects.first
    object.object_types.size.should == 1
    object.object_types.first.should =~ /song/
    object.title.should == "Sure Looks Good To Me"
    object.author.should == "Alicia Keys"
    
    object.links.size.should == 1
    object.links.first.should == "http://www.last.fm/music/Alicia+Keys/_/Sure+Looks+Good+To+Me"
  end
  
  it "should have an activity:actor on the first entry" do
    object = @feed.entries.first.actor
    object.should_not be_nil
  end
  
  it "should parse a proper activity:actor" do
    object = @feed.entries.first.actor
    object.object_types.size.should == 1
    object.object_types.first.should =~ /person/
    object.title.should == "krani1"
  end
end

describe ActivityStreams, "myspace" do
  before :all do
    @myspace_json = IO.read(File.expand_path(File.dirname(__FILE__) + "/myspace.json"))
    @feed = ActivityStreams::Feed.from_json(@myspace_json)
  end
  
  it "should parse myspace example" do
    @feed.should_not be_nil
  end
  
  it "should have 1 entry" do
    @feed.entries.size.should == 1
  end
  
  it "should have tite, id and published on each entry" do
    @feed.entries.first.title.should == "Someone posted a photo"
    @feed.entries.first.id.should == "11923759128375912735912"
    @feed.entries.first.published.class.should == Time
  end  
  
  it "should have a list of activity:verb on the first entry" do
    verbs = @feed.entries.first.verbs
    verbs.class.should == Array
    verbs.size.should == 1
    verbs.first.should =~ /post/
  end
  
  it "should have a list of activity:object on the first entry" do
    objects = @feed.entries.first.objects
    objects.class.should == Array
    objects.size.should == 1
  end
  
  it "should parse a proper activity:object" do
    object = @feed.entries.first.objects.first
    object.object_types.size.should == 1
    object.object_types.first.should =~ /photo/
    object.title.should == ""
    object.author.should == nil
    
    object.links.size.should == 1
    object.links.first.should == "http://c2.ac-images.myspacecdn.com/images02/6/s_be8bb90eebb4c8725724f66dcb9414f1.png"
  end
  
  it "should have an activity:actor on the first entry" do
    object = @feed.entries.first.actor
    object.should_not be_nil
  end
  
  it "should parse a proper activity:actor" do
    object = @feed.entries.first.actor
    object.object_types.size.should == 1
    object.object_types.first.should =~ /person/
    object.title.should == "Brandon Black"
  end
end