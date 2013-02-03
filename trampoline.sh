#!/bin/sh

set -e

PACMAN="pacman --quiet --noconfirm"
SYNC="${PACMAN} --sync"
QUERY="${PACMAN} --query"

ready_pacman () {
	${SYNC} --refresh
}

ok () {
	type $1 > /dev/null
}

ready_babushka () {
	PACKAGES="curl ruby"
	${QUERY} ${PACKAGES} || ${SYNC} ${PACKAGES}

	ok babushka || sh -c "`curl https://babushka.me/up`" < /dev/null
}

bootstrap () {
	NAME=$1
	babushka sources --add ${NAME} https://github.com/quad/${NAME}.git
	babushka ${NAME}:bootstrap
}

ready_pacman
ready_babushka
bootstrap karen
