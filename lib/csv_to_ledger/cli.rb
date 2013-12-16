require 'csv'
require 'csv_to_ledger/formatter'

module CSVToLedger
  class CLI

    attr_reader :input_file 
    attr_reader :csv_settings
    attr_reader :vendor_account_matcher
    attr_accessor :output

    def initialize(input_file)
      @input_file = input_file
      @csv_settings = {:headers => true,
                      :col_sep => ',',
                      :header_converters => [lambda {|h| h.strip}, :symbol]}
      @vendor_account_matcher = VendorAccountMatcher.new
      @output = ""
    end

    def prompt_for_account(transaction)
      out = new_stdout

      out.puts("No account for #{transaction.summary}.")
      out.puts("Please enter an existing (tab to autocomplete) or a new one.")

      Readline.completion_proc = proc do |input|
        vendor_account_matcher.accounts.grep(/^#{Regexp.escape(input)}/)
      end

      Readline.output = out

      account = Readline.readline('account: ', true)
      vendor_account_matcher.add_vendor_account(transaction.description, account)
      account
    end

    def run
      CSV.foreach(input_file, csv_settings) do |row|
        output << create_transaction(row)
      end
      puts output
    end

    def new_stdout
      fd = IO.sysopen("/dev/tty", "r+")
      IO.new(fd, "w+")
    end

    def create_transaction(row)
      Transaction.new do |t|
        t.date = row[:date]
        t.description = Formatter.filter_description(row[:transaction_details])
        t.funds_out = row[:funds_out]
        t.funds_in = row[:funds_in]
        t.account = vendor_account_matcher.match(t.description) || prompt_for_account(t).capitalize
      end
    end
  end
end
