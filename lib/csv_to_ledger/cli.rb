module CSVToLedger
  class CLI
    attr_reader :input_file, :csv_settings
    attr_reader :vendor_account_matcher

    def initialize(input_file)
      @input_file = input_file
      @csv_settings = {:headers => true,
                      :col_sep => ',',
                      :header_converters => [lambda {|h| h.strip}, :symbol]}
      @vendor_account_matcher = VendorAccountMatcher.new
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

    def prompt_for_account(transaction)
      puts("No account for #{transaction.summary}.")
      puts("Please enter an existing (tab to autocomplete) or a new one.")

      Readline.completion_proc = proc do |input|
        vendor_account_matcher.accounts.grep(/^#{Regexp.escape(input)}/)
      end

      account = Readline.readline('account: ', true)
      vendor_account_matcher.add_vendor_account(transaction.description, account)
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
          t.account = vendor_account_matcher.match(t.description) || prompt_for_account(t).capitalize
        end
      end

      output
    end
  end
end
