Rails.application.routes.draw do
	root "home#index"

	get '/payment' => "home#payment"

	post '/success' => "home#pay_success"

	post '/failure' => "home#pay_failure"

	get '/message' => "home#message"
end
