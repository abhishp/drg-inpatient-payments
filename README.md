# Patient Data Retrieval System

This is a very simple system with an easy to use API to search patient data.

### Requirements

* Ruby (~> 2.4.1)
* Rails (~> 5.1.4)
* Postgresql (~> 9.6)
 
### Dev Setup

1. Install Ruby
    ```
    brew install rbenv ruby-build
    
    # Add rbenv to bash so that it loads every time you open a terminal
    echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
    source ~/.bash_profile
    
    # Install Ruby
    rbenv install 2.4.1
    rbenv global 2.4.1
    ruby -v 
    ```
2. Bundle Setup   
  `bundle install`

3. Setup Database   
    ```
    rake db:setup
    rake db:migrate
    ```