#!/usr/bin/env python
"""
Checks whether mozilla-inbound is open or closed.

Pull requests welcome on https://github.com/bnjvr/.files

CC0
To the extent possible under law, Benjamin Bouvier has waived all copyright and related or neighboring rights to inbound-status. This work is published from: France.
"""

import urllib2
import json

URL = 'https://treestatus.mozilla-releng.net/trees2'

red_start = '\033[1;31m'
green_start = '\033[1;32m'
purple_start = '\033[1;35m'
end = '\033[0m'

def main():
    try:
        req = urllib2.Request(url=URL)
        f = urllib2.urlopen(req)
        trees = json.loads(f.read()).get('result', None)
    except Exception as e:
        print 'Error: ', e
        return

    if trees is None:
        print "The API seems to have changed: 'result' doesn't exist anymore."
        return

    infos = []
    for t in trees:
        name = t.get('tree')
        if name == 'mozilla-inbound' or name == 'mozilla-central':
            name = purple_start + name

        status = t.get('status')

        color = green_start if status == 'open' else red_start

        maybe_reason = ' ({})'.format(t.get('reason')) if status != 'open' and len(t.get('reason')) > 0 else ""
        infos.append("{}: {}{}{}{}".format(name, color, status.upper(), maybe_reason, end))

    infos.sort()
    print '\n'.join(infos)

if __name__ == '__main__':
    main()
