# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :view_customizes
  put :view_customizes, to: 'view_customizes#update_all'
end
