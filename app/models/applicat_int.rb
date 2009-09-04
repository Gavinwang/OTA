require "prawn"
require "prawn/layout"

class ApplicatInt < Prawn::Document 
  IMG =  "#{RAILS_ROOT}/public/images/hc/logo.png"  
  def self.Header(pdf)
    pdf.header pdf.margin_box.top_left do
      pdf.image IMG
      pdf.move_down 15
      pdf.stroke_horizontal_rule
    end
  end

end