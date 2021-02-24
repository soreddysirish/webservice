# require 'savon'
# require 'pry'
# require 'rails'
# class SoapApi
# 	attr_reader :client
# 	def initialize
# 		@url = "https://wstest.creditinfo.co.tz/Multiconnector/MultiConnector.svc?singleWSDL"
# 		# @client = Savon.client(wsdl: "http://localhost:3000/rumbas/wsdl")
# 		@client = Savon.client(wsdl: @url,log: true)


# 	end
# 	def multihit_request
# 		xml_file = File.read("/Users/codingmart/Downloads/yabx/ExampleRequestsWithReturnResponses/SingleHitCreditinfoReportRequest.xml")
# 		response = @client.call(:query,xml: xml_file)
# 		p response.body
# 	end
# 	def generate_object
# 		response = @client.call(:generate_object)
# 		p response.body
# 	end
# end
# xml_create = SoapApi.new
# xml_create.multihit_request
# # xml_create.generate_object


require 'savon'
require 'nokogiri'
require 'securerandom'

xml_definition = "https://wstest.creditinfo.co.tz/Multiconnector/MultiConnector.svc?singleWSDL"
# Update your file path for request format.
# raw_xml = File.read("./SingleHitCreditinfoReportRequest.xml")
raw_xml = File.read("/Users/codingmart/Downloads/yabx/ExampleRequestsWithReturnResponses/SingleHitCreditinfoReportRequest.xml")

xml_doc = Nokogiri::XML(raw_xml)
xml_doc.at('//text()[.="${=java.util.UUID.randomUUID()}"]').content = SecureRandom.uuid
xml_request = xml_doc.to_xml
xml_request.sub! '${=java.util.UUID.randomUUID()}', "#{SecureRandom.uuid}"

client = Savon.client(wsdl: xml_definition, log: true, pretty_print_xml: true)
response = client.call(:query, xml: xml_request)