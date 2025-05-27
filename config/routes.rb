Rails.application.routes.draw do
  resources :users do
    resources :books do
      resources :loans
    end
  end
end
