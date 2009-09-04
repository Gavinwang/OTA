class ReferenceInfoController < ApplicationController
  before_filter:authorize
  layout "user"
  protect_from_forgery :except => [:upload, :show, :reference_info]

  def upload
    #�ϴ�
    if params[:file]!=nil && params[:file]!=""
      fileTemp = params[:file].read
      fileName = params[:file].original_filename
      fileMime = fileName.split(".")[-1]
      tempName = (DateTime.now.to_s+"."+fileMime).gsub(/-/i, "_").gsub(/:/i, "_").gsub(/\+/i, "_")
      if fileTemp
        path = "/public/uploads/"
        File.open("#{RAILS_ROOT}"+path+tempName, "wb") do |f|
          f.write(fileTemp)
        end
      end
      #д����ݿ�
      @reference = ReferenceInfo.new
      @reference.file_real_name = fileName
      @reference.file_stone_name = tempName
      @reference.file_url = path
      @reference.profile_id = session[:profile_id]
      if @reference.save
        session[:r]=1
        linkUrl = "#{RAILS_ROOT}/public/uploads/"+tempName
        linkTxt = fileName
        redirect_to :action=>:reference_info, :returnUrl=>linkUrl, :returnTxt=>linkTxt
      else
        hint = "Upload fail ..."
        logger.error("Upload file failed: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)   
        redirect_to :action=>:reference_info, :hint=>hint
      end
    else
      flash[:notice] = "Chose a file first."
      render :action => :reference_info
    end
  end

  #dom����
  def download
    begin
      send_file "public/files/"+ params[:filename] unless params[:filename].blank?
    rescue Exception=>e
      logger.error("Download file failed: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
      logger.error(e)
      flash[:notice] = "Download failed and the exception is#{e}"     
    end
  end

  #int����
  def downloadintel
    begin
      send_file "public/files/"+ params[:filenameintel] unless params[:filenameintel].blank?
    rescue Exception=>e
       logger.error("Download file failed: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
      logger.error(e)
      flash[:notice] = "Download failed and the exception is#{e}"   
    end
  end

  #�ϴ����ļ��б�
  def reference_info
    @titlelogo ="reference"
    @hint = params[:hint]
    @linkUrl=params[:returnUrl]
    @linkTxt=params[:returnTxt]
    @references = ReferenceInfo.find_all_by_profile_id(session[:profile_id])
  end

  #ɾ���ϴ����ļ�
  def delete
    if ReferenceInfo.delete(params[:id])
      flash[:notice] = "The file you choice was successfully delete."  
      redirect_to :action => :reference_info
    end
  end
end

