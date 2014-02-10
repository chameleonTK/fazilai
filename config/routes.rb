Fazilai::Application.routes.draw do
  get "/", to: "app#index" , as:'index'
  post "/", to: "authen#login" 

  get "/signup", to: "authen#signup" , as:'singup'
  post "/signup", to: "authen#signupdata"
  get "/logout", to: "authen#logout"

  get "/choose", to: "app#choose" , as:'home'
  post "/choose/createdomain", to: "app#createdomain" ,as:'createdomain'

  get "/server", to: "app#server" , as:'server'
  get   "/listfile" ,to: "app#listfile" ,as: "listfile_root"
  get "/profile", to: "app#profile" , as:'profile' 
  post "/profile", to: "app#profiledata" 
  get   "/listfile/*dirname" ,to: "app#listfile" , as: 'listfile'
  get "/log", to: "app#log"
end
