# app/services/tax_calculator.rb
class TaxCalculator
    TAX_RATES = {
      'AB' => { gst: 0.05, pst: 0.0, hst: 0.0 }, # Alberta
      'BC' => { gst: 0.05, pst: 0.07, hst: 0.0 }, # British Columbia
      'MB' => { gst: 0.05, pst: 0.07, hst: 0.0 }, # Manitoba
      'NB' => { gst: 0.05, pst: 0.0, hst: 0.15 }, # New Brunswick
      'NL' => { gst: 0.05, pst: 0.0, hst: 0.15 }, # Newfoundland and Labrador
      'NS' => { gst: 0.05, pst: 0.0, hst: 0.15 }, # Nova Scotia
      'NT' => { gst: 0.05, pst: 0.0, hst: 0.0 }, # Northwest Territories
      'NU' => { gst: 0.05, pst: 0.0, hst: 0.0 }, # Nunavut
      'ON' => { gst: 0.05, pst: 0.0, hst: 0.13 }, # Ontario
      'PE' => { gst: 0.05, pst: 0.0, hst: 0.15 }, # Prince Edward Island
      'QC' => { gst: 0.05, pst: 0.09975, hst: 0.0 }, # Quebec
      'SK' => { gst: 0.05, pst: 0.06, hst: 0.0 }, # Saskatchewan
      'YT' => { gst: 0.05, pst: 0.0, hst: 0.0 }  # Yukon
    }
  
    def self.calculate_total_price(subtotal, province_code)
      tax_rate = TaxRate.find_by(province: Province.find_by(code: province_code))
      return { subtotal: subtotal, gst: 0.0, pst: 0.0, hst: 0.0, total_price: subtotal } unless tax_rate
  
      gst = tax_rate.gst
      pst = tax_rate.pst
      hst = tax_rate.hst
  
      gst_amount = subtotal * gst
      pst_amount = subtotal * pst
      hst_amount = subtotal * hst
      total_tax = gst_amount + pst_amount + hst_amount
      total_price = subtotal + total_tax
  
      {
        subtotal: subtotal,
        gst: gst_amount,
        pst: pst_amount,
        hst: hst_amount,
        total_price: total_price
      }
    end
  end
  