# Lunch Spots App

## Overview

The Lunch Spots app is an API built with Rails that uses Google Places for finding restaurants to eat at. A walkthrough of how a user would use the API is as follows:
- Sign up with an email address and password
- User is issued an API key
- Use the API key to obtain a JSON web token
- Pass the JSON web token to the `/search` endpoint through a header along with parameters specifying the location and type of food
- Restaurant results are returned in an array, including the name, photo URL, rating, latitude and longitude, and if it's open now.

## Rails app

User registration through the web interface is handled with the Devise gem.

I used a Postgres database to store a simple Users table. There is also a Spots table which is intended to store user-favorited restaurants. If I were to continue this project, I would create another migration to add a one-to-many relationship between the users and spots. Spot records would be created as users favorited them.

After a user signs up an API key is created for them. This is used in requesting a JWT for making `curl` requests to the API. The JWTs are cached and expire after 2 hours.

#### Local development

You can run the app locally if you have Rails & Postgres installed, or through [docker-compose](https://docs.docker.com/compose/). To use docker-compose:

```
docker-compose build
docker-compose run web rake db:create # Create the db for the first time
docker-compose run web rake db:migrate # Initial migration
docker-compose up
```

From there you can view the sign up page at `http://localhost:3000/users/sign_up`. After you sign up, instructions for how to use the API are given on the profile page:
![API instructions](docs/images/instructions.png?raw=true)

## Kubernetes deployment

The app is also deployed to a Kubernetes cluster in DigitalOcean with a managed database hosted there as well. The load balancer can be reached from its external IP: `http://167.99.27.34/users/sign_in`

Files for the various K8s resources can be found in `config/kube`.

![API instructions](docs/images/k8s-architecture.png?raw=true)

The cluster is fairly simple: it consists of a deployment, which is responsible for maintaining 3 pod replicas running containers of the Rails app. The image for these is pushed to Docker Hub.

The `prod-db-creds` secrets for the environment variables in the deployment were created straight through the kubectl CLI tool so they didn't get commited to the repo:
```
kubectl create secret generic prod-db-creds \
--from-literal='username=<username>' \
--from-literal='password=<password>' \
--from-literal='host:<host>'
```

The HorizontalPodAutoscaler will increase the number of pods running if the server becomes more burdened. To test this out, you could use something like [slow cooker](https://github.com/BuoyantIO/slow_cooker).

The load balancer service is responsible for routing traffic to the pods.

Finally, the network policy specifies where ingress and egress is allowed from. The ingress was left open intentionally so anyone could access it--although depending on the usecase, if this was an internal company app, it could be tightened.

## TODO

Given more time, I would make the following improvements:
- Add RSpec tests for model methods, test the controllers with request specs, and also add route specs.
- Encrypt the user API keys in the db.
- Have JWT be revoked if a user account is deleted.
- Manage the DigitalOcean resource creation through Terraform.
- Add DNS and TLS.