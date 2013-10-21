require 'test_helper'

module Blogue
  class PostTest < ActiveSupport::TestCase
    test 'sort_posts reverse-sorts posts by time' do
      post_a = OpenStruct.new(time: 3.hours.ago)
      post_b = OpenStruct.new(time: 2.hours.ago)
      array = [post_a, post_b]
      assert_equal [post_b, post_a], array.sort{|a, b| Post.sort_posts(a, b)}
    end

    test 'extract_post_id extracts id from path' do
      assert_equal 'blogue-post',
        Post.extract_post_id('app/posts/blogue-post.md')
    end

    test 'extract_post_id extracts id from path with multiple extensions' do
      assert_equal 'blogue-post',
        Post.extract_post_id('app/posts/blogue-post.md.erb')
    end

    test 'finds post by id' do
      assert Post.find('minimal-post')
    end

    test 'uses filename as title when no other alternative' do
      assert_equal 'Minimal post', Post.find('minimal-post').title
    end

    test 'uses markdown header as title if present' do
      assert_equal 'A title header', Post.find('header-title').title
    end

    test 'uses meta title if present' do
      assert_equal 'A title provided in meta', Post.find('meta').title
    end

    test 'uses file creation time when no meta date' do
      assert_equal File.ctime('test/fixtures/posts/minimal-post.md').utc.to_s,
        Post.find('minimal-post').time.utc.to_s
    end

    test 'uses time from meta when given' do
      assert_equal '1986-12-12 12:12:12 UTC', Post.find('meta').time.utc.to_s
    end

    test 'date returns date part of time' do
      assert_equal '1986-12-12', Post.find('meta').date.to_s
    end
  end
end
