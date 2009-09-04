class ReferenceInfo < ActiveRecord::Base
   validates_format_of :file_real_name,
                     :with => /.+(\.doc|\.docx|\.pdf|\.txt)/,
                     :message => "Upload file format ..."
   validates_presence_of :file_real_name,
                     :message => "Please select a valid file for uploading."
end
