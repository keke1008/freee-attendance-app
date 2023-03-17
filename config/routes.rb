Rails.application.routes.draw do
  devise_for :managers, path: 'manager', controllers: {
    registrations: 'managers/registrations',
    sessions: 'managers/sessions'
  }

  resource :manager

  devise_for :employees, path: 'employee', controllers: {
    registrations: 'employees/registrations',
    sessions: 'employees/sessions'
  }

  resource :employee do
    patch 'punch_in', as: :punch_in
    patch 'punch_out', as: :punch_out
  end

  root 'root#index'
end
