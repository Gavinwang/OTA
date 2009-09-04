require 'fpdf'

class Cuappint < FPDF
# include Reloadable
   def Header
      Image("#{RAILS_ROOT}/public/images/p_header.PNG",60,35,185,45)
      SetFont('Arial','',10) 
      Text(320,75,"DOMESTIC Online M.Ed Application - Page" + PageNo().to_s )
      SetLineWidth(1)
      Line(45,80,550,80)
   end
end