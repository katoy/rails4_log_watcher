class MydataController < ApplicationController


  def edit
    edit_params
    @mydata = Mydata.new
  end

  def create
    @mydata = Mydata.new(create_params[:mydata])
    unless @mydata.valid?
      render 'edit'
      return
    end
  end

  private

  def edit_params
    params.permit([:utf8, :authenticity_token, :mydata, :commit])
  end

  def create_params
    params.permit([:utf8, :authenticity_token, :mydata, :commit,
                   mydata:[:foo, :bar, :piyo]])
  end
end
