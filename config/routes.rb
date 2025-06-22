Rails.application.routes.draw do
  get "calendar/index"
  devise_for :users, controllers: { 
  omniauth_callbacks: 'users/omniauth_callbacks' 
}
end
