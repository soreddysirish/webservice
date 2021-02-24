namespace :savon_request do 
	task request: :environment do 
		xml_definition = "https://wstest.creditinfo.co.tz/Multiconnector/MultiConnector.svc?singleWSDL"
		raw_xml = File.read("#{Rails.root}/app/views/xml_views/SingleHitCreditinfoReportRequest.xml")
		xml_doc = Nokogiri::XML(raw_xml)
		xml_doc.at('//text()[.="${=java.util.UUID.randomUUID()}"]').content = SecureRandom.uuid
		xml_request = xml_doc.to_xml
		xml_request.sub! '${=java.util.UUID.randomUUID()}', "#{SecureRandom.uuid}"
		client = Savon.client(wsdl: xml_definition)
		response = client.call(:query, xml: xml_request)
		
		json  = response.body
		record_data = json[:query_response][:query_result][:response_xml][:response][:connector][:data][:response][:custom_report][:cip][:record_list][:record]
		count = 0
		headers =%w{date grade probability_of_default score trend reason_code reason_description}
		CSV.open("singlehitresponse.csv","wb",headers:true) do |csv|
			csv << headers
			record_data.each do |record|
				obj = {}
				obj["date"]=  record[:date]
				obj["grade"]=  record[:grade]
				obj["probability_of_default"]=  record[:probability_of_default]
				obj["score"]=  record[:score]
				obj["trend"]=  record[:trend]
				record[:reasons_list][:reason].each do |reason|
					count +=1
					obj["reason_code"] = reason[:code]
					obj["reason_description"] = reason[:description]
					Record.create(obj)
					csv << [record[:date],record[:grade],record[:probability_of_default],record[:score],record[:trend],reason[:code],reason[:description]]
				end
			end
		end
		p "#{count} of records created"
	end
end
 # log: true, pretty_print_xml: true
 # json = JSON.parse(Hash.from_xml(xml_data).to_json)