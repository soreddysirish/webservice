class Api::V1::BureauclientController < ApplicationController
	skip_before_action :verify_authenticity_token
	def get_score
		request_obj = {}
		request_obj["username"]="imsmart"
		request_obj["password"]="Imb*255"
		request_obj["fullname"]= params["fullname"]
		request_obj["phonenumber"]= params["phonenumber"]
		request_obj["idnumber"]= params["idnumber"]
		request_obj["idNumberType"]= params["idNumberType"]
		request_obj["dateOfBirth"]= params["dateOfBirth"]
		xml_definition = "https://wstest.creditinfo.co.tz/Multiconnector/MultiConnector.svc?singleWSDL"
		request_obj["random_key"] = SecureRandom.uuid
		request_xml = ActionController::Base.new.send(:render_to_string, template:  "xml_views/SingleHitCreditinfoReportRequest",locals:{request_obj:request_obj})
		tmp_file = "#{Rails.root}/tmp/SingleHitCreditinfoReportRequest.xml"
		File.open(tmp_file, 'wb') do |f|
			 f.write request_xml
		end
		raw_xml = File.read("#{Rails.root}/tmp/SingleHitCreditinfoReportRequest.xml")
		client = Savon.client(wsdl: xml_definition)
		response = client.call(:query, xml: raw_xml)
		json  = response.body
		record_data = json[:query_response][:query_result][:response_xml][:response][:connector][:data][:response][:custom_report][:cip][:record_list][:record]
		count = 0
		headers =%w{date grade probability_of_default score trend reason_code reason_description fullname phonenumber idnumber idNumberType dateOfBirth}
		max_score = []
		CSV.open("singlehitresponse.csv","wb",headers:true) do |csv|
			csv << headers
			record_data.each do |record|
				obj = {}
				obj["fullname"]= request_obj["fullname"]
				obj["phonenumber"] = request_obj["phonenumber"]
				obj["idnumber"] = request_obj["idnumber"]
				obj["idNumberType"]= request_obj["idNumberType"]
				obj["dateOfBirth"] = request_obj["dateOfBirth"]
				obj["date"]=  record[:date]
				obj["grade"]=  record[:grade]
				obj["probability_of_default"] =  record[:probability_of_default]
				obj["score"]=  record[:score]
				max_score << record[:score].to_i
				obj["trend"]=  record[:trend]
				record[:reasons_list][:reason].each do |reason|
					count +=1
					obj["reason_code"] = reason[:code]
					obj["reason_description"] = reason[:description]
					Record.create(obj)
					csv << [record[:date],record[:grade],record[:probability_of_default],record[:score],record[:trend],reason[:code],reason[:description],obj["fullname"],obj["phonenumber"],obj["idnumber"],obj["idNumberType"],obj["dateOfBirth"]]
				end
			end
		end
		render json:{score: max_score.max()}
		p "#{count} of records created"
	end
end
