class VendorAccountMatcher
  attr_accessor :tags

  def initialize
    @matcher = get_tags_to_vendors
  end

  def get_tags_to_vendors
    filename = "../test-data/tags.json"      
    JSON.load(open(filename))
  end
end
