### 0.1.0

* Add Rails 4.2 support
* Add Blogue.markdown_template_preprocessor for hooking into template processing
* Include ActiveModel::Naming, Conversion, #persisted? => true into Blogue::Post
* Add convenience reader Blogue.started_at that returns time when Rails booted

* Remove accessor Blogue.blanket_checksum_calc
* Remove accessor Blogue.default_markdown_format_handler
* Remove accessor Blogue.default_markdown_codeblock_handler
* Remove accessor Blogue.blanket_checksum

* Rename Blogue.markdown_format_handler => markdown_template_handler
* Rename Blogue.checksum_calc => compute_post_cache_key
* Rename Blogue.checksums => posts_cache_keys
* Rename Blogue.blanket_checksum => cache_key

* Make Blogue.markdown_template_handler a reader (not accessor)
* Make Blogue.posts_cache_keys a reader (not accessor)
* Make Blogue.cache_key a reader (not accessor)

* Change accessor Blogue.assets_path to support callable objects

### 0.0.6

* Move default handler lambdas to default_* accessors for better extensibility
* Add Post.load_meta to access meta parsing without post object

### 0.0.5

* Add Post#cache_key and Post.cache_key for using fragment caching in Rails

### 0.0.4

* Fix problem where images in assets_path did not precompile
* Only hide private posts in production

### 0.0.3

* Add private posts by using _filename or setting private: true in meta

### 0.0.2

* Add `Post#author_name` that uses meta || `Blogue.author_name` || `whoami`

### 0.0.1

* Initial release
