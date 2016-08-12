# Introduction
This is a mockup of a medication management and tracking tool for post stroke patients. This was built for a capstone project of the 2SMART team at Mobile Health Training Institute, UCLA, August 2016.

## Screenshots
![alt-text](https://raw.githubusercontent.com/davehdo/mhti-med-manager/master/public/Screenshot%202016-08-12%2010.03.28.png)
![alt-text](https://raw.githubusercontent.com/davehdo/mhti-med-manager/master/public/Screenshot%202016-08-12%2010.04.12.png)
![alt-text](https://raw.githubusercontent.com/davehdo/mhti-med-manager/master/public/Screenshot%202016-08-12%2010.04.26.png)
![alt-text](https://raw.githubusercontent.com/davehdo/mhti-med-manager/master/public/Screenshot%202016-08-12%2010.04.53.png)


# Getting started

## This app uses the Heroku-ready RAM stack
[More information on the RAM stack is found here](https://bitbucket.org/davehdo/ram-stack/)

### Server side
* Rails 4.2.4
* Mongodb

### Client side
* Angular
* Jquery
* Coffee
* Lodash
* Moment.js

### Styling
* Sass
* Bootstrap
* Fontawesome ```<i class="fa fa-camera-retro"></i>```


## Configure the database
1. Update config/mongoid.yml to point the database to the correct location. You could use a local mongodb installation or a cloud-based service like MongoLab

## How to add another field to the scaffold

1. Prepare the rails back-end for receiving, storing, and returning the new field

* In app/models/patient.rb, add a line
```
field :field_name, type: String
```

* In app/controllers/patients_controller.rb, scroll to the permit method and whitelist the field name
```
params.require(:patient).permit(:name, :field_name)
```

* In app/views/patients/index.json.jbuilder and app/views/patients/show.json.jbuilder
add the name of the field to the extract method
```
json.extract! @patient, :id, :name, :field_name
```

2. Update the front end form to display the field   

* In assets/javascripts/templates/patients/show.html, add the field to the template
```
{{ patient.field_name}}
```
* In assets/javascripts/templates/_form.html.erb, add a form object to edit the field

## Deploying to Heroku (and mLab for MongoDB)
1. Create a new app in Heroku
1. Provision a mLab Add-on
1. This should automatically add an environment variable in Heroku called MONGODB_URI that has all the information necessary to connect to the mongo database. The value should take the following format:
```
mongodb://username:password@host1:port1,host2:port2/database
```
1. Update mongoid.yml with the appropriate settings to connect to mLab
```
production:
    clients:
        default:
            uri: "<%= ENV['MONGODB_URI'] %>"

            options:
                max_retries: 30
                retry_interval: 1
                timeout: 15
                refresh_interval: 10
```

1.create database indexes
```
rake db:mongoid:create_indexes
```
