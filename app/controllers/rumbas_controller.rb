require 'savon'
class RumbasController < ApplicationController
	soap_service namespace: 'urn:WashOut'
	soap_action "multihit_request",:args   => {:url=> :string},:return => :string
	soap_action "generate_object",:args   => {},:return => :string
	def multihit_request
	client = Savon.client(wsdl: params["url"],soap_header: {
    "Header" => { "id" => "22636b5b-067f-48ae-86f6-cf6a900b7408",username:'imsmart',password:'Imb*255' }})
		xml_file = File.read("#{Rails.root}/app/views/xml_views/SingleHitCreditinfoReportResponse.xml")
		# res = client.call(:list_connectors, xml: xml_file)
		binding.pry
		response = HTTParty.post(params["url"], :body => xml_file, :headers => { 'Content-Type' => 'text/xml', 'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,/;q=0.8'} )
		# request_xml =  ActionController::Base.new.send(:render_to_string, template:  "xml_views/MultihitRequest",locals:{username: params["username"],password:params["password"],messageid:params["messageid"],idnumber:params["idnumber"],idnumbertype:params["idnumbertype"]})
		# obj = {}
		# obj["request_xml"] =  request_xml
		#   response_obj = [{address:"Tanzania",creditInfoId: 13639505,dateOfBirth:"1993-05-09T21:00:00Z",fullName: "sirish kumar",votersId:45643689,mobilePhone:87976533},{address:"India",creditInfoId: 13639505,dateOfBirth:"1994-05-09T21:00:00Z",fullName: "JOFRE  ELASTO",votersId:12345678,mobilePhone:43452331324}]
		#   response_xml = ActionController::Base.new.send(:render_to_string, template:  "xml_views/MultiHitWithSubjectInfosResponse",locals:{response_obj:response_obj})
		#   obj["response_xml"] = response_xml
		# res =  HTTParty.post(params["url"])
		render :soap => obj.to_json
	end

	def generate_object
		xml_data = File.read("#{Rails.root}/app/views/xml_views/SingleHitCreditinfoReportResponse.xml")
		json = JSON.parse(Hash.from_xml(xml_data).to_json)
		record_data = json["Envelope"]["Body"]["QueryResponse"]["QueryResult"]["ResponseXml"]["response"]["connector"]["data"]["response"]["CustomReport"]["CIP"]["RecordList"]["Record"]
		count = 0
		record_data.each do |record|
			obj = {}

			obj["date"]=  record["Date"]
			obj["grade"]=  record["Grade"]
			obj["probability_of_default"]=  record["ProbabilityOfDefault"]
			obj["score"]=  record["Score"]
			obj["trend"]=  record["Trend"]
			record["ReasonsList"]["Reason"].each do |reason|
				count +=1
				obj["reason_code"] = reason["Code"]
				obj["reason_description"] = reason["Description"]
				Record.create(obj)
			end
		end
		render :soap => "#{count.to_s} records created"
	end
end

                               
                                