Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  scope '/repositories/:owner/:repository' do
    #http://127.0.0.1:3000/repositories/aruprakshit/curly-palm-tree/commits/c9ffbe71594f7fa/diff
    get '/commits/:oid/diff',  controller: 'repositories/commits', action: 'diff'
    
    ## http://127.0.0.1:3000/repositories/aruprakshit/curly-palm-tree/commits/c9ffbe71594f7fa/
    get '/commits/:oid', controller: 'repositories/commits', action: 'show'

  end
end
