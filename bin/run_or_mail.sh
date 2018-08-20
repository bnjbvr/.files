#!/bin/bash

### Sends an email to an administrator if a task didn't work as expected.

FROM_EMAIL=bots@myserver.com
TO_EMAIL=admin@example.com

ID=$RANDOM

if ! "$@" > /tmp/run-$ID.log 2>&1
then
    cat > /tmp/mail-$ID <<- EOM
From: $FROM_EMAIL
To: $TO_EMAIL
Subject: Failure when running $@

$(cat /tmp/run-$ID.log)
.
EOM
    sendmail $TO_EMAIL < /tmp/mail-$ID
    rm /tmp/mail-$ID
fi

rm /tmp/run-$ID.log
