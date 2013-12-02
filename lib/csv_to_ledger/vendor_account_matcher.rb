require 'sequel'

module CSVToLedger
  DB = Sequel.connect('sqlite://db/production')

  class VendorAccountMatcher
     attr_accessor :matchers_file, :accounts, :matchers

    def initialize
      @matchers = fetch_matchers
      @accounts = @matchers['select account from items']
    end

    def match(vendor)
      fetch_vendor(vendor)
    end

    def add_vendor_account(vendor, account)
      save_matcher(vendor, account)
    end

    def accounts
      @accounts = matchers.values.uniq
    end

    private

    def fetch_vendor(vendor)
      matchers.fetch(vendor, nil)
    end

    def fetch_matchers
      DB[:matchers]
    end

    def save_matcher(vendor, account)
      matchers.insert(vendor: vendor, account: account)
    end
  end
end
