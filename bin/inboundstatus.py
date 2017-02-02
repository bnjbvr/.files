#!/usr/bin/env python
"""
Checks whether mozilla-inbound is open or closed.

Pull requests welcome on https://github.com/bnjvr/.files

CC0
To the extent possible under law, Benjamin Bouvier has waived all copyright and related or neighboring rights to inbound-status. This work is published from: France.
"""

import urllib2
import json

URL = 'https://treestatus.mozilla.org/trees/mozilla-inbound'

red_start = '\033[2;31m'
green_start = '\033[2;32m'
end = '\033[0m'

def main():
    try:
        req = urllib2.Request(url=URL)
        f = urllib2.urlopen(req)
        r = json.loads(f.read()).get('result', None)
    except Exception as e:
        print 'Error: ', e
        return

    if r is None:
        print "The API seems to have changed: 'result' doesn't exist anymore."
        return

    status = r.get('status', '?')

    color = green_start if status == 'open' else red_start

    msg = status.upper()
    if msg != 'OPEN':
        msg += '\n' + r.get('reason', '(undocumented reason)')

    print color + msg + end

if __name__ == '__main__':
    main()
