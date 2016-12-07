PROJECT = lotto
PROJECT_DESCRIPTION = Lotto project
PROJECT_VERSION = 0.0.1

DEPS = gproc

#SHELL_OPTS =  +P 5000000  +K true  -pa ebin -pa deps/*/ebin -boot start_sasl  -config dev.config  -s rb  -s lotto_app -sname lotto_app
SHELL_OPTS = +P 1000000 -s lotto

include erlang.mk
