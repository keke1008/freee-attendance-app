Rails.application.routes.draw do
  devise_for :employees

  devise_for :managers, path: 'manager', controllers: {
    registrations: 'managers/registrations',
    sessions: 'managers/sessions'
  }

  resource :manager

  root 'root#index'
end
