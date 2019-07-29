### Task rules
  * Part 1.

    * Replace ranges in the given string with the shortened form. e. g. `'abcdab987612' => 'a-dab9-612`

    * Wrap the long lines in the given text to the given length. Example:
      ```
        'To be or not to be that is the question', 5 => 
        To be
        or 
        not
        to be
        that
        is
        the
        quest
        ion
      ```
  * Part 2.

    * We have the YAML file with the translations in the simple format (translations_simple.yml, attached). We want to use it with the rails [I18n] system.
Write a program that will transform the translations from simple format into a YAML file that can be used in the rails application.
      
      ```      
      translations_simple.yml
      'en.pets.types.cat': Cat
      'en.pets.types.dog': Dog
      'en.pets.title': My lovely pets
      'en.actions.add': Add
      'en.actions.remove': Remove
      'en.language': <strong>Language</strong>```
      
       translations.yml - resulting file
        en:
             pets:
               types:
                 cat: Cat
                 dog: Dog
             title: My lovely pets
             actions:
               add: Add
               remove: Remove
             language: <strong>Language</strong>
### Task res
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
