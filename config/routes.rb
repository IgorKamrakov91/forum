Rails.application.routes.draw do
  devise_for :users

  resources :forum_threads do
    resources :forum_posts, module: :forum_threads
  end

  resources :users do
    collection do
      post :import
    end
  end

  root 'forum_threads#index'

  default_url_options :host => "example.com"
end
