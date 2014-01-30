Fazilai::Application.routes.draw do
  get "/", to: "app#index" , as:'index'
  post "/", to: "authen#login" 

  get "/signup", to: "authen#signgup" , as:'singup'
  post "/signup", to: "authen#signdata"
  get "/logout", to: "authen#logout"

  get "/choose", to: "app#choose" , as:'home'
  get "/server", to: "app#server" , as:'server'
  get   "/listfile" ,to: "app#listfile" ,as: "listfile_root"
  get   "/listfile/*dirname" ,to: "app#listfile" , as: 'listfile'

  
end
