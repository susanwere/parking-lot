# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/tickets', to: 'tickets#create'
    get '/tickets', to: 'tickets#index'
    get '/tickets/:barcode', to: 'tickets#get_by_barcode', as: 'get_by_barcode'
  end
end
