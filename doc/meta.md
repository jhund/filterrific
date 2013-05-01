# Workflow to Maintain This Gem

1. Update code and commit it.
2. Bump the version with one of the rake tasks:
   * `rake version:bump:patch` 1.5.3 -> 1.5.4
   * `rake version:bump:minor` 1.5.3 -> 1.6.0
   * `rake version:bump:major` 1.5.3 -> 2.0.0
   * `rake version:write MAJOR=2 MINOR=3 PATCH=6` 1.5.3 -> 2.3.6
3. Add entry to CHANGELOG:
   * h1 for major release
   * h2 for minor release
   * h3 for patch release
4. Release it.
   * `rake release`
   * Optionally release it to Rubyforge: `rake rubyforge:release`
   * Optionally release it to Gemcutter: `rake gemcutter:release`
5. Rinse and repeat


http://prioritized.net/blog/gemify-assets-for-rails/
