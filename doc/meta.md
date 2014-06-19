Workflow to Maintain This Gem
=============================

I use the gem-release gem

For more info see: https://github.com/svenfuchs/gem-release#usage

Steps for an update
-------------------

1. Update code and commit it.
2. Add entry to CHANGELOG and commit it:
   * h1 for major release
   * h2 for minor release
   * h3 for patch release
3. Bump the version with one of these commands:
   * `gem bump --version 1.1.1` # Bump the gem version to the given version number
   * `gem bump --version major` # 0.0.1 -> 1.0.0
   * `gem bump --version minor` # 0.0.1 -> 0.1.0
   * `gem bump --version patch` # 0.0.1 -> 0.0.2
4. Release it.
   * `gem release`
5. Create a git tag and push to origin.
   `gem tag`


http://prioritized.net/blog/gemify-assets-for-rails/



How to run specs
----------------

`bundle exec rake`
