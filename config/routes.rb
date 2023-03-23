Rails.application.routes.draw do
  devise_for :managers, path: 'manager', controllers: {
    registrations: 'managers/registrations',
    sessions: 'managers/sessions'
  }

  resource :manager, only: :show do
    get 'attendances/:employee_id', action: :attendances

    resources :employees, controller: 'managers/employees', only: :show do
      resources :attendances, controller: 'managers/employees/attendances', except: :index do
        post 'detail', on: :member
      end
      resources :shifts, controller: 'managers/employees/shifts', except: :index do
        post 'detail', on: :member
      end
    end
  end

  devise_for :employees, path: 'employee', controllers: {
    registrations: 'employees/registrations',
    sessions: 'employees/sessions'
  }

  resource :employee, only: :show do
    patch 'punch_in', as: :punch_in
    patch 'punch_out', as: :punch_out
  end

  root 'root#index'
end
