Fazilai::Application.routes.draw do
  get "/", to: "app#index" , as:'index'
  post "/", to: "authen#login" 

  get "/home/:user", to: "app#home" , as:'home'
  get "/signup", to: "authen#signgup" , as:'singup'
  post "/signup", to: "authen#signdata"
  get "/logout", to: "authen#logout"
  
end
