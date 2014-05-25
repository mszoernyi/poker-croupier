#!/bin/bash

SLEEP_SECS=5

for i in {1..60} ;do

    echo "starting tournament at "$(date +"%Y_%m_%d_%H_%M_%S")

    bundle exec ruby croupier/scripts/start_tournament.rb > /dev/null
    STATUS=$?

    if [[ ${STATUS} -ne 0 ]]; then
        break;
    fi

    echo "going to sleep for ${SLEEP_SECS} seconds; now is $(date)"
    sleep ${SLEEP_SECS}

done
