module ApplicationHelper
    def provinces_list
      [
        ['Alberta', 'AB'],
        ['British Columbia', 'BC'],
        ['Manitoba', 'MB'],
        ['New Brunswick', 'NB'],
        ['Newfoundland and Labrador', 'NL'],
        ['Northwest Territories', 'NT'],
        ['Nova Scotia', 'NS'],
        ['Nunavut', 'NU'],
        ['Ontario', 'ON'],
        ['Prince Edward Island', 'PE'],
        ['Quebec', 'QC'],
        ['Saskatchewan', 'SK'],
        ['Yukon', 'YT']
      ]
    end

    def percentage_off(original_price, sale_price)
      return 0 if original_price.nil? || sale_price.nil? || original_price.zero?
  
      percentage = ((original_price - sale_price) / original_price) * 100
      percentage.round(2)
    end

      def percentage_off(original_price, sale_price)
        return 0 if original_price.zero?
    
        ((original_price - sale_price) / original_price * 100).round
      end
  end
