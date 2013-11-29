require 'json'

module CSVToLedger
  class VendorAccountMatcher
    attr_accessor :filename, :matchers, :accounts
        
    def initialize
      @filename = "test-data/tags.json"
      @matchers = fetch_matchers
      @accounts = @matchers.values.uniq
    end

    def match(vendor)
      fetch_vendor(vendor)
    end
    
    def add_vendor_account(vendor, account)
      matchers[vendor] = account
      save_matchers
    end

    private
    
    def fetch_vendor(vendor)
      matchers.fetch(vendor, nil)
    end

    def fetch_matchers
      matchers || JSON.load(open(filename))
    end

    def save_matchers
      JSON.dump(open(filename))
    end

  end
end
