require 'test_helper'

class ConfigurationTest < ActionDispatch::IntegrationTest
  test 'renders markdown with kramdown' do
    get '/header-title'
    assert_match '<h1 id="a-title-header">A title header</h1>', response.body
  end

  test 'renders codeblocks with rouge' do
    get '/code-block'
    assert_match '<span class="k">def</span>', response.body
  end

  test 'adds [posts_path]/assets to rails asset paths' do
    get '/assets/dogue.jpg'
    assert_equal 'image/jpeg', response.content_type.to_s
  end
end
