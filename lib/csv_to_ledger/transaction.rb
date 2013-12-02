module CSVToLedger
  class Transaction
    attr_accessor :date
    attr_accessor :description
    attr_accessor :funds_out
    attr_accessor :funds_in
    attr_accessor :account
    attr_reader :total_in_or_out

    def initialize(&block)
      yield self if block_given?
    end

    def expense?
      @funds_out.to_i > 0
    end

    def total_in_or_out
      expense? ? funds_out : funds_in
    end

    def summary
      "'#{description}: $#{total_in_or_out}'"
    end

    def to_s
      "#{date} #{description}\n" +
      if expense?
        "\t Expense:#{account}: \t #{funds_out}\n"+
          "\t Liabilities:Chequing"
      else
        "\t Asset:Chequing: \t #{funds_in}\n"+
          "\t Income:PayCheque: "
      end
    end

    def to_str
      to_s
    end

    private
  end
 end
