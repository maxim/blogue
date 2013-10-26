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
