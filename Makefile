PROJECT = lotto
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0


#SHELL_OPTS =  +P 5000000  +K true  -pa ebin -pa deps/*/ebin -boot start_sasl  -config dev.config  -s rb  -s lotto_app -sname lotto_app
SHELL_OPTS = -s lotto

include erlang.mk
