#!/usr/bin/env python
"""
Checks whether mozilla-inbound is open or closed.

Pull requests welcome on https://github.com/bnjvr/.files

CC0
To the extent possible under law, Benjamin Bouvier has waived all copyright and related or neighboring rights to inbound-status. This work is published from: France.
"""

import urllib2
import json

URL = 'https://treestatus.mozilla.org/mozilla-inbound?format=json'

red_start = '\033[2;31m'
green_start = '\033[2;32m'
end = '\033[0m'

try:
    req = urllib2.Request(url=URL)
    f = urllib2.urlopen(req)
    r = json.loads(f.read()).get('status', None)
    color = red_start
    if r == 'open':
        color = green_start
    print color + r.upper() + end
except Exception as e:
    print 'Error: ', e
