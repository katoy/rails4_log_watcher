# coding: utf-8
module LogHelper

  def log(status, message)
    str = "#{caller.first}: message"
    # puts str

    log = Operationallog.new
    log.status = status
    log.message = str
    log.save!
  end

end
