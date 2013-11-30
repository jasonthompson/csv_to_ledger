require 'json'

module CSVToLedger
  class VendorAccountMatcher
    attr_accessor :matchers_io, :matchers, :accounts

    def initialize(matchers_io)
      @matchers_io = matchers_io
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
      matchers || open(matchers_io) do |f| JSON.load(f) end
    end

    def save_matchers
      open(matchers_io, "w") do |f| JSON.dump(matchers, f) end
    end

  end
end
