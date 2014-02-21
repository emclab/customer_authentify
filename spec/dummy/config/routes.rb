Rails.application.routes.draw do

  mount CustomerAuthentify::Engine => "/customer_authentify"
  mount Authentify::Engine => '/authentify'
end
