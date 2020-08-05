The solution of the task is in the app directory.

However I decided to create an environment that will allow not only to execute the code, but also to generate necessary varnish log file and to perform rspec tests.

To start whole environment you need to use command: 

`docker-compose up`

To run the code you have to login to docker container:

`docker exec -it dfw-app bash`

## Preparing Varnish Log File

Instead of putting already generated file to the repository I created a simple environment which allows to simulate an example traffic and generate a log file. To prepare `varnishncsa.log` file additional script must be executed:

`$ ./generate_varnish_log.rb`

This script makes `100_000` requests to a sinatra server located on docker container `dfw-sinatra`. Requests are being served by varnish located on the container `dfw-varnish`.

## Running Script

To run script script please type command:

`$ ./script.rb`

## Running Tests

Tests can be run with:

`$ rspec`