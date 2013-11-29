#!/usr/bin/env ruby
require 'csv'
require 'json'
require 'pry'

module CSVToLedger
  class Vendor
    attr_accessor :accounts

    def initialize
      @accounts = get_accounts
    end

    def get_accounts
      # filename = "/home/jason/ledger/vendor-to-account.json"
      # accounts_dictionary = {}
      json = %q(
{
    "Dorego Supermar": "Groceries",
    "Nuthouse": "Groceries",
    "Rowe Farms": "Groceries",
    "West End Food C": "Groceries",
    "Caya Co-operati": "Groceries",
    "Family Fruit An": "Groceries",
    "Tim Hortons #29": "Coffee/Snacks",
    "Second Cup": "Coffee/Snacks",
    "Green Beanery": "Coffee/Snacks",
    "Jimmys Coffee": "Coffee/Snacks",
    "Pizzaiolo": "Restaurant",
    "Jo Fresh Queen": "Clothing",
    "Abm Interac Charge": "Bank Fees",
    "Le Gourmand Caf": "Restaurant",
    "Utility Bill Payment Enbridge": "Utilities",
    "Insurance Meloche Monnex/securite Nat'l": "Household"
}
)
      JSON.parse(json)
    end
  end

  class Transaction

    attr_reader :date
    attr_reader :description
    attr_reader :funds_out
    attr_reader :funds_in
    attr_reader :account

    def initialize(args={})
      @date = filter_date(args[:date])
      @description = filter_description(args[:description])
      @funds_out = args[:funds_out]
      @funds_in = args[:funds_in]
      @account = choose_account(description)
    end

    def choose_account(description)
      vendor = Vendor.new
      vendor.accounts.fetch description, "No Account"
    end

    def expense?
      @funds_out.to_i > 0
    end

    private

    def filter_date(date_string)
      m,d,y = date_string.split('/')
      return "#{y}/#{m}/#{d}"
    end

    def filter_description(description)
      description.gsub!('POS MERCHANDISE ', '')
      title_caps description.downcase
    end

    def title_caps(str)
      arr = str.split
      new = []
      arr.each{|w| new << w.capitalize}
      new.join(" ")
    end
  end

  output = []

  CSV.foreach('/home/jason/bank-data.csv') do |row|
    date, description, funds_out, funds_in = row
    output << Transaction.new(date: date,
                              description: description,
                              funds_out: funds_out,
                              funds_in: funds_in)
  end


  #output.select {|r| ! r[:funds_in].nil?}
  output.each do |r| 
    puts "#{r.date} #{r.description}\n" +
      if r.expense?
        "\t Expense:#{r.account}: \t #{r.funds_out}\n"+
          "\t Liabilities:Chequing"
      else
        "\t Asset:Chequing: \t #{r.funds_in}\n"+
          "\t Income:PayCheque: "
      end
  end
end
