#!/usr/bin/env ruby
require 'csv_to_ledger'

require 'csv'
require 'json'
require 'pry'
require 'highline/import'

module CSVToLedger
  class Conversion
    attr_reader :input_file, :csv_settings
    attr_reader :vendor_account_matcher

    def initialize(input_file)
      @input_file = input_file
      @csv_settings = {:headers => true,
                      :col_sep => ',',
                      :header_converters => [lambda {|h| h.strip}, :symbol]}
      @vendor_account_matcher = VendorAccountMatcher.instance()
    end

    def title_caps(str)
      arr = str.split
      new = []
      arr.each{|w| new << w.capitalize}
      new.join(" ")
    end

    def filter_description(description)
      description.gsub!('POS MERCHANDISE ', '')
      title_caps description.downcase
    end

    def prompt_for_new_account(transaction)
      account = ask("Please enter new account name for #{transaction.summary}: ", String)
      account
    end

    def prompt_for_account(transaction)
      say("No account for #{transaction.summary}.")

      account = ""

      choose do |menu|
        menu.prompt = "Please choose an account for #{transaction.summary}: "

        menu.choice :add do |c| 
          new_acct = prompt_for_new_account(transaction) 
          account << vendor_account_matcher.add_vendor_account(transaction.description, account)
        end

        vendor_account_matcher.accounts.each do |a| 
          menu.choice a do |c| 
            account << vendor_account_matcher.add_vendor_account(transaction.description, c)
          end
        end
      end
      account
    end

    def run
      output = ""

      CSV.foreach(input_file, csv_settings) do |row| 
        output << Transaction.new do |t|
          t.date = row[:date]
          t.description = filter_description(row[:transaction_details])
          t.funds_out = row[:funds_out]
          t.funds_in = row[:funds_in]
          t.account = vendor_account_matcher.match(t) || prompt_for_account(t)
        end
      end

      output
    end
  end
  c = Conversion.new(ARGF.path)
  c.run
end
