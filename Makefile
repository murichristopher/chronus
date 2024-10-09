RUNNING_RABBIT := $(shell docker ps -a --filter "name=my_rabbit" --format "{{.Names}}")

start:
	mix run --no-halt

console:
	iex -S mix

rabbit:
ifeq ($(RUNNING_RABBIT), my_rabbit)
	docker start my_rabbit
else
	docker run --name my_rabbit -p 5672:5672 -p 15672:15672 -d rabbitmq:3.13-management
endif



