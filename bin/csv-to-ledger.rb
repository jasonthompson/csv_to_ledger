#!/usr/bin/env ruby
require 'csv_to_ledger'

require 'csv'
require 'json'
require 'pry'
require 'highline/import'

module CSVToLedger
  output = []

  def self.title_caps(str)
    arr = str.split
    new = []
    arr.each{|w| new << w.capitalize}
    new.join(" ")
  end

  def self.filter_description(description)
    description.gsub!('POS MERCHANDISE ', '')
    title_caps description.downcase
  end

  def self.prompt_for_new_account(vendor)
    say("No account for #{vendor}.")

    account = choose do |menu|
      menu.prompt = "Please choose an account for this vendor"
      matcher = VendorAccountMatcher.new("test-data/tags.json")
      matcher.accounts.each do |a|
        menu.choice a do matcher.add_vendor_account(vendor, a) end
      end
    end
    account
  end

  CSV.foreach('test-data/PCF.csv') do |row|
    date, description, funds_out, funds_in = row
    description = filter_description(description)
    matcher = VendorAccountMatcher.new("test-data/tags.json")
    account = matcher.match(description) || prompt_for_new_account(description)
    
    output << Transaction.new(date: date,
                        description: description,
                        funds_out: funds_out,
                        funds_in: funds_in,
                        account: account)
  end

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
