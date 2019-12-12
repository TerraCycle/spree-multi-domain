Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :stores do
      collection do
        get 'search'
      end
    end
  end
end
