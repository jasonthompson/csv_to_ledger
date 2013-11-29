module CSVToLedger
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
      @account = args[:account]
    end

    def expense?
      @funds_out.to_i > 0
    end

    private

    def filter_date(date_string)
      m,d,y = date_string.split('/')
      return "#{y}/#{m}/#{d}"
    end

  end
 end
