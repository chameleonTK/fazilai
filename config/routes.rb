Fazilai::Application.routes.draw do
  get "/", to: "app#index" , as:'index'
  post "/", to: "authen#login" 

  get "/signup", to: "authen#signgup" , as:'singup'
  post "/signup", to: "authen#signdata"
  get "/logout", to: "authen#logout"

  get "/choose", to: "app#choose" , as:'home'
  post "/choose/createdomain", to: "app#createdomain" ,as:'createdomain'
  
end
