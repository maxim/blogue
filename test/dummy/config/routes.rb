Dummy::Application.routes.draw do
  root to: 'posts#index'

  Post.all.each { |post| get "/#{post.id}", to: 'posts#show', id: post.id }
end
