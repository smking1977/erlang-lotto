PROJECT = lotto
PROJECT_DESCRIPTION = Lotto project
PROJECT_VERSION = 0.0.1

DEPS = gproc cowboy jsx
dep_cowboy = git https://github.com/ninenines/cowboy 1.0.4

#SHELL_OPTS =  +P 5000000  +K true  -pa ebin -pa deps/*/ebin -boot start_sasl  -config dev.config  -s rb  -s lotto_app -sname lotto_app
SHELL_OPTS = +P 3000000  -config dev.config -boot start_sasl  -s  lotto

include erlang.mk
