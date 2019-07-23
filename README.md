*  Deployment:
    * Clone this repo
    * Ruby version 2.4.2. For an auto switch to the desired version Ruby, you can use rvm, asdf, rbenv
    * Install gem bundler if it needs and run: `$ bundle install`
* Tests: 
    * Run all tests 
         ```
         $ rake test
         ```
    * You can run these tests separately too:
        ```
        $ ruby test/assignment/justifier_test.rb
        $ ruby test/assignment/squasher_test.rb
        $ ruby test/assignment/tree_builder_test.rb
        ```