Rails.application.routes.draw do
  get 'getData', to: 'data#gen'
  get '/', to: 'data#gen'
  get ENV["API_PATH"], to: 'data#gen'
end
