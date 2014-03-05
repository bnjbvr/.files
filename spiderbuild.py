#!/usr/bin/env python
import subprocess

JS_ROOT = '/home/ben/code/moz/inbound/js/src/configure'

options = (
        ('GGC', '--enable-gcgenerational --enable-exact-rooting', ''),
        ('debug mode', '--enable-debug', '--disable-debug'),
        ('opt mode', '--enable-optimize', '--disable-optimize'),
        ('ccache', '--with-ccache', ''),
        ('intl', '', '--without-intl-api'),
        ('perf support', '--enable-perf', ''),
        ('trace logging', '--enable-trace-logging', ''),
)

initial_str = ''
cfg = JS_ROOT + ' ' + initial_str
env = {}

def get_yesno_answer(question):
    while True:
        try:
            rep = raw_input(question)
            if rep == 'y' or rep == 'Y':
                return True
            elif rep == 'n' or rep == 'N':
                return False
            else:
                raise Exception
            break
        except:
            print('Only possible answers are y or n')

for name, yes, no in options:
    if get_yesno_answer('Would you like to activate ' + name + '? '):
        if len(yes) > 0:
            cfg += ' ' + yes
    else:
        if len(no) > 0:
            cfg += ' ' + no

if get_yesno_answer('32 bits builds?'):
    env['CC'] = '"gcc -m32 -march=pentiumpro"'
    env['CXX'] = '"g++ -m32 -march=pentiumpro"'
    env['AR'] = 'ar'
    cfg += " --target=i686-pc-linux"
    if get_yesno_answer('arm simulator build?'):
        cfg += ' --enable-arm-simulator'

envString = ' '.join(['%s=%s' % (k, env[k]) for k in env])
print envString + ' ' + cfg
while True:
    a = raw_input("Would you like to run it (r), save it (s), or quit (q) ?")
    if a == 'r':
        run_args = [arg for arg in cfg.split(' ') if len(arg) > 0]
        print run_args
        p = subprocess.Popen(run_args, stdout=subprocess.PIPE, env=env)
        print p.communicate()[0]
        break
    if a == 's':
        name = raw_input("Give it a name:")
        HEADER = "#!/bin/bash\n"
        f = file(name, "w+")
        f.write(HEADER)
        f.write(envString + ' ' + cfg)
        f.close()
        break
    if a == 'q':
        break
