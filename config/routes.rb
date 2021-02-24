Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  wash_out :rumbas
  namespace :api do 
  	namespace :v1 do 
  		post '/bureauclient' => 'bureauclient#get_score'
  	end
  end
end

