Rails.application.routes.draw do
  devise_for :users
  root 'blogs#index' #追記
  resources :blogs
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  if Rails.env.development?
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    # mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  end
end
