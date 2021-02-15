class RumbasController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  soap_action "concat",
              :args   => { :a => :string, :b => :string },
              :return => :string
  def concat
    render :soap => (params[:a] + params[:b])
  end
end
