Rails.application.routes.draw do
	get '/getdata', to: 'rumbas#generate_object'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  wash_out :rumbas
end

