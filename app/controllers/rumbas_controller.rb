class RumbasController < ApplicationController
	soap_service namespace: 'urn:WashOut'
	soap_action "multihit_request",:args   => { :username => :string, :password => :string,:messageid => :string,:idnumber => :string, :idnumbertype => :string},
	:return => :string
	def multihit_request
		request_xml =  ActionController::Base.new.send(:render_to_string, template:  "xml_views/MultihitRequest",locals:{username: params["username"],password:params["password"],messageid:params["messageid"],idnumber:params["idnumber"],idnumbertype:params["idnumbertype"]})
		obj = {}
		obj["request_xml"] =  request_xml
		  response_obj = [{address:"Tanzania",creditInfoId: 13639505,dateOfBirth:"1993-05-09T21:00:00Z",fullName: "sirish kumar",votersId:45643689,mobilePhone:87976533},{address:"India",creditInfoId: 13639505,dateOfBirth:"1994-05-09T21:00:00Z",fullName: "JOFRE  ELASTO",votersId:12345678,mobilePhone:43452331324}]
		  response_xml = ActionController::Base.new.send(:render_to_string, template:  "xml_views/MultiHitWithSubjectInfosResponse",locals:{response_obj:response_obj})
		  obj["response_xml"] = response_xml
		render :soap => obj.to_json
	end
end



                               
                                