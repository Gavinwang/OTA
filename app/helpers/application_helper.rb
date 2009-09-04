module ApplicationHelper
  #��ʾ����ԭ��
  def errors_for(object, attribute)
    #err = ""
    #if (object!=nil)
    #  for i in attribute do
    #    if errors = object.errors.on(i)
    #      errors = [errors] unless errors.is_a?(Array)
    #      err += "<ul style='color: Red;'>" + errors.map {|e| "<li>" + e + "</li>"}.join + "</ul>"
    #    end
    #  end
    #end
    #return err
    if (object!=nil)
      for i in attribute do
        if errors = object.errors.on(i)
          iserror =true
        end
      end
    end
    if(iserror)
      return "<ul name='cw' id='cw' style='color: Red;'>* Some <i>required information</i> is missing or incomplete. Please check your entries and try again.</ul>"
    end
  end

  #��ʾ����ĸ�̾��
  def has_error(object, attribute)
    if (object!=nil)
      if errors = object.errors.on(attribute)
        errors = [errors] unless errors.is_a?(Array)
        return "<span class='mark'>!</span>"
      end
    end
  end

end
