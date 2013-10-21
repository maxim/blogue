# Blogue

Blogue is the static page blog that is also a rails engine. It means that you get all of rails, yet your blog is static. Best of both worlds.

## What you get

* A `Blogue::Post` model
* Handler for ".md" views ([kramdown](https://github.com/gettalong/kramdown/) by default)
* Syntax highlighting for code blocks ([rouge](https://github.com/jayferd/rouge) by default)

## What you don't get

* Mountable endpoint
* Default controllers
* Default views
* Generators

You just hook it up by hand any way you want.

## Usage

1. Generate a rails app (or use existing)
2. Add all needed gems to Gemfile and bundle
  ~~~ruby
  gem 'kramdown'
  gem 'rouge'
  gem 'blogue'
  ~~~

3. Create a model `app/models/post.rb` (the name 'Post' is chosen at random)
  ~~~ruby
  class Post < Blogue::Post
    # Here you can override inherited methods any way you like.
    # See app/models/blogue/post.rb to see what you have
  end
  ~~~

4. Create a controller `app/controllers/posts_controller.rb`
  ~~~ruby
  class PostsController < ApplicationController
    def index
      @posts = Post.all
    end

    def show
      @post = Post.find(id)
    end
  end
  ~~~

5. Add a route to your `config/routes.rb` like this
  ~~~ruby
  # If you want an index page
  root to: 'posts#index'

  # Whitelist of your posts
  Post.all.each { |post| get "/#{post.id}", to: 'posts#show', id: post.id }
  ~~~

6. Add `app/views/posts/index.html.erb` for your index page
  ~~~erb
    <% @posts.each do |post| %>
    <p>
      <%= link_to post.title, post.id %>

      <% if post.tldr %>
      <blockquote>
        <%= post.tldr %>
      </blockquote>
      <% end %>
    </p>
    <% end %>
  ~~~

7. Add `app/views/posts/show.html.erb` for your post page
  ~~~erb
  <%= link_to 'index', root_path %>

  <%=raw render file: @post.path %>

  <% if @post.date %>
  <p>Published on <%= @post.date.to_s(:long) %></p>
  <% end %>
  ~~~

8. Create a directory `app/posts` (that's default location of posts)
9. Create a directory `app/posts/assets` (it's added to assets paths by default)
10. Add a post like `app/posts/my-first-post.md`  
        # Yay my first post

        This is some text.

        ![picture](/assets/picture.jpg)

        ~~~ruby
        foo = 'foo' # a codeblock
        ~~~

        <!--meta
          date: 2013-10-21
          tldr: Awesome
        -->

11. Start server and go to http://localhost:3000/my-first-post
