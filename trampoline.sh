#!/bin/sh

set -e

ready_babushka () {
	type babushka || sh -c "`curl https://babushka.me/up`" < /dev/null
}

bootstrap () {
	NAME=$1
	babushka sources --add ${NAME} https://github.com/quad/${NAME}.git
	babushka ${NAME}:bootstrap
}

ready_babushka
bootstrap karen
