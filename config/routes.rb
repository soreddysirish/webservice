Rails.application.routes.draw do
	get 'hello_message/wsdl', to: 'hello_message#hello_message'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  wash_out :rumbas
end

