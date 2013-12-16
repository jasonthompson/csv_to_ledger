module CSVToLedger
  class Formatter
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
  end
end
