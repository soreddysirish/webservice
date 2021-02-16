class RumbasController < ApplicationController
	soap_service namespace: 'urn:WashOut'
	soap_action "generate_xml",
	:args   => { :username => :string, :password => :string,:messageid => :string,:idnumber => :string, :idnumbertype => :string},
	:return => :string
	def generate_xml
		builder = Nokogiri::XML::Builder.new do |xml|
			xml['s'].Envelope('xmlns:s' => "http://schemas.xmlsoap.org/soap/envelope/") {
				xml['s'].Header(){
					xml['wsse'].Security('s:mustUnderstand' => "1","xmlns:wsse"=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"){
						xml['wsse'].UsernameToken("wsu:Id"=>"SecurityToken-ad2b9f33-eba3-4e0f-ae41-e90379b97f56", "xmlns:wsu"=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"){
							xml['wsse'].Username(params["username"])
							xml['wsse'].Password(params["password"])
						}
					}
				}
				xml['s'].Body {
					xml.Query("xmlns"=>"http://creditinfo.com/schemas/2012/09/MultiConnector"){
						xml.request("xmlns:i" =>"http://www.w3.org/2001/XMLSchema-instance"){
							xml.MessageId(params["messageid"])
							xml.RequestXml(){
								xml.RequestXml("xmlns"=>"http://creditinfo.com/schemas/2012/09/MultiConnector/Messages/Request"){
									xml.connector("id"=>"22636b5b-067f-48ae-86f6-cf6a900b7408"){
										xml.data("id"=>"random number"){
											xml.request("xmlns"=>"http://creditinfo.com/schemas/2012/09/MultiConnector/Connectors/Bee/Request","xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance","xsi:schemaLocation"=>"http://creditinfo.com/schemas/2012/09/MultiConnector/Connectors/Bee/Request file:/C:/Users/d.felix/Desktop/Smart%20Search/Smart%20Search/TZA_NMB_BeeRequest.xsd"){
												xml.DecisionWorkflow "NMB.TZA.Base"
												xml.RequestData(){
													xml.Individual(){
														xml.IdNumbers(){
															xml.IdNumberPairIndividual(){
																xml.IdNumber(params["idnumber"])
																xml.IdNumberType(params["idnumbertype"])
															}
														}
														xml.InquiryReasons("ApplicationForCreditOrAmendmentOfCreditTerms")
														xml.CreditInfoId("CreditInfoId")
														xml.TypeOfReport("CreditinfoReportPlus")
													}
												}
											}

										}
									}
								}
							}
							xml.Timeout("i:nil"=>"true")
						}
					}
				}
			}
		end
		xml_data = builder.to_xml
		tmp_file = "#{Rails.root}/tmp/soap.xml"
		File.open(tmp_file, 'wb') do |f|
			f.write xml_data
		end
		render :soap => (xml_data)
	end

	def generate_object
	xml = File.open("#{Rails.root}/tmp/soap.xml")
	data = Hash.from_xml(xml)
	security_info = data["Envelope"]["Header"]["Security"]["UsernameToken"]
	obj ={
		username:security_info["Username"],
		password:security_info["Password"]
	}
	render json: obj
	end
end
