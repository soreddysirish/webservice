require 'savon'
require 'pry'

class SoapApi
	attr_reader :client
	def initialize
		@client = Savon.client(wsdl: "http://localhost:3000/rumbas/wsdl")
	end
	def multihit_request
		response = @client.call(:multihit_request, message: { :username => "sirish", :password => "1234",:messageid => "456789",:idnumber => "4576",:idnumbertype => "string"})
		response = JSON.parse(response.body[:multihit_request_response][:value])
		p "********* request xml *******************"
			p response["request_xml"]
		p "********* End ofrequest xml *******************"

		p "********* response xml *******************"
			p response["response_xml"]
		p "********* End of response xml *******************"
	end
end
xml_create = SoapApi.new
xml_create.multihit_request
