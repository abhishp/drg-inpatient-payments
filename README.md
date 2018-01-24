# Patient Data Retrieval System

This is a very simple system with an easy to use API to search patient data.

Features
* A validated and paginated search API at `/providers` with support for following filters: 
  * state
  * min_discharges
  * max_discharges
  * min_average_covered_charges
  * max_average_covered_charges
  * min_average_medicare_payments
  * max_average_medicare_payments
  * min_average_total_payments
  * max_average_total_payments
  * page
  * page_size

* Any request to `/providers` can be further refined using `fields` filter. 
Using `fields` filter would only fetch the specified fields, thus making your response faster and lighter.

* A React based front-end client which provides a validated form and renders results in a responsive/adaptive manner.

[API - Demo](http://drg-inpatient-payments.us-west-1.elasticbeanstalk.com)

[Demo](http://drg-inpatient-payments.us-west-1.elasticbeanstalk.com)

-----

Development
------
#### Requirements

* Ruby (~> 2.3.5)
* Rails (~> 5.1.4)
* Postgresql (~> 9.6)

#### Setup
1. Install Ruby
    ```
    brew install rbenv ruby-build
    
    # Add rbenv to bash so that it loads every time you open a terminal
    echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
    source ~/.bash_profile
    
    # Install Ruby
    rbenv install 2.3.5
    rbenv global 2.3.5
    ruby -v
    ```
2. Install Postgres    
    Install postgres server using this [guide](https://gist.github.com/sgnl/609557ebacd3378f3b72)
    
3. Clone this repo    
    `git clone 'https://github.com/abhishp/drg-inpatient-payments.git'`
    
4. Bundle Setup   
    ```
    cd drg-inpatient-payments
    bundle install
    ```

5. Setup Database   
    To create the databases required for development and also migrate and seed them as needed run the following command
    ```
    rake db:create
    rake db:setup
    ```
    
6. Running tests    
   Use the `rspec` command to run the tests.
    
6. Run Server   
    `rake start`    
    This will start both the servers (Rails and React) in development mode.
