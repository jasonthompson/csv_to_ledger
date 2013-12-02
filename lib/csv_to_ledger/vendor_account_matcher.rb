require 'sequel'

module CSVToLedger
  DB = Sequel.connect('sqlite://db/development')

  class VendorAccountMatcher
    def match(vendor)
      acct = nil
      unless fetch_vendor(vendor).empty?
        acct = fetch_vendor(vendor).first[:account]
      end
      acct
    end

    def add_vendor_account(vendor, account)
      save_matcher(vendor, account)
    end

    def all
      matchers.all
    end

    def accounts
      accts = []
      fetch_accounts.each do |a|
        accts << a[:account]
      end
      accts.uniq
    end

    private

    def matchers
      DB[:matchers]
    end

    def fetch_vendor(vendor)
      matchers.where(:vendor => vendor).all
    end

    def fetch_accounts
      matchers.select(:account).all
    end

    def save_matcher(vendor, account)
      matchers.insert(vendor: vendor, account: account)
    end
  end
end
