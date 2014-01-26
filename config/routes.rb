Fazilai::Application.routes.draw do
  get "/", to: "app#home"
  post "/", to: "authen#login"
  get "/singup", to: "authen#singup"
  post "/singup", to: "authen#signdata"
  post "/logout", to: "authen#logout"
  
end
