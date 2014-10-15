# Workflow to Maintain This Gem

I use the gem-release gem

For more info see: https://github.com/svenfuchs/gem-release#usage



## Steps for an update

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



## How to run specs

`bundle exec rake`



## Travis CI

Filterrific uses Travis CI for testing. We test filterrific code directly here
in the gem. We test Rails integration in the filterrific_demo app. There we have
a branch for each minor version of Rails that is tested and supported.

Sequence of a release:

* finish updates in filterrific
* run specs in each filterrific_demo branch (via `rake`)
* when all specs pass, release filterrific (see above for steps)
* after new filterrific is released, add new release version to each branch in
  filterrific_demo and push each branch to trigger a Travis CI build for the
  new filterrific release.
