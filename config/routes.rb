# Rails.application.routes.draw do

 Spree::Core::Engine.add_routes do

  namespace :admin do 
    resources :zipcodes
  end

end
