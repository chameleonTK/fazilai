Fazilai::Application.routes.draw do
  get "/", to: "app#index" , as:'index'
  post "/", to: "authen#login" 

  get "/signup", to: "authen#signup" , as:'singup'
  post "/signup", to: "authen#signupdata"
  get "/logout", to: "authen#logout"

  get "/choose", to: "app#choose" , as:'home'
  get "/profile", to: "app#profile" , as:'profile' 
  get "/setting", to: "app#setting", as:'setting'
end
