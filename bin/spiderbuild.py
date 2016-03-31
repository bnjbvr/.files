#!/usr/bin/env python
import subprocess
import os
import stat
import json

################
# Configure here
################

if os.path.exists(os.path.expanduser('~/.spiderbuild.conf')):
    f = file(os.path.expanduser('~/.spiderbuild.conf'), 'r')
    config = json.load(f)
    f.close()
    BASE_ROOTS = config.get('base_root', None)
    AVAILABLE_VARIANTS = config.get('variants', [''])
else:
    as_dict = dict()
    BASE_ROOTS = as_dict['base_root'] = raw_input('Where is your mozilla base dir repo?')
    AVAILABLE_VARIANTS = as_dict['variants'] = [''] # TODO
    f = file(os.path.expanduser('~/.spiderbuild.conf'), 'a+')
    json.dump(as_dict, f)
    f.close()

# Default answers to questions (n for no, y for yes)
USE_CLANG = 'n'
COMPILE_32_BITS = 'n'
COMPILE_ARM_SIMULATOR = 'n' # needs COMPILE_32_BITS to be 'y' if you want to set as 'y'
COMPILE_ARM64_SIMULATOR = 'n' # needs COMPILE_32_BITS to be 'n' if you want to set as 'y'
COMPILE_MIPS_SIMULATOR = 'n' # needs COMPILE_32_BITS to be 'y' if you want to set as 'y'
ENABLE_DEBUG = 'y'
ENABLE_OPTIMIZE = 'n'
ENABLE_CCACHE = 'y'
ENABLE_INTL = 'n'
ENABLE_PERF = 'n'
ENABLE_TRACELOGGING = 'n'
ENABLE_THREAD_SAFETY = 'y'
ENABLE_ASAN = 'n'
ENABLE_TSAN = 'n'
ENABLE_VALGRIND = 'n'
ENABLE_ION = 'y'
ENABLE_STATIC_ANALYSIS = 'n'

DEFAULT_BUILD_SCRIPT_NAME = 'build.sh'

# Enjoy
PATH_TO_JS_CONFIGURE= '/js/src/configure'
AVAILABLE_ROOTS = [BASE_ROOTS + v + PATH_TO_JS_CONFIGURE for v in AVAILABLE_VARIANTS]

if COMPILE_ARM_SIMULATOR != COMPILE_32_BITS:
    COMPILE_ARM_SIMULATOR = 'n'
if COMPILE_MIPS_SIMULATOR != COMPILE_32_BITS:
    COMPILE_MIPS_SIMULATOR = 'n'
if COMPILE_ARM64_SIMULATOR == COMPILE_32_BITS:
    COMPILE_ARM64_SIMULATOR = 'n'

print 'Available roots:'
i = 0
for r in AVAILABLE_ROOTS:
    print i, r
    i += 1

root = ''
if len(AVAILABLE_ROOTS) == 1:
    print "Choosing first root, no other choice."
    root = AVAILABLE_ROOTS[0]
else:
    while True:
        root = raw_input('Choose your root: ')

        if len(root) == 0:
            print "Don't be lazy, write something."
            continue

        try:
            root = int(root)
            if root < len(AVAILABLE_ROOTS):
                root = AVAILABLE_ROOTS[root]
                if root is not None:
                    break
            print 'there is no such available root'
        except Exception as e:
            print 'not a valid root name'
            root = ''

JS_ROOT = root
print 'The chosen root is', JS_ROOT

options = (
        ('debug mode', '--enable-debug', '--disable-debug', ENABLE_DEBUG),
        ('opt mode', '--enable-optimize', '--disable-optimize', ENABLE_OPTIMIZE),
        ('ccache', '--with-ccache', '', ENABLE_CCACHE),
        ('intl', '', '--without-intl-api', ENABLE_INTL),
        ('perf support', '--enable-perf', '', ENABLE_PERF),
        ('trace logging', '--enable-trace-logging', '', ENABLE_TRACELOGGING),
        ('thread safety', '', '--disable-threadsafe', ENABLE_THREAD_SAFETY),
        ('valgrind', '--enable-valgrind', '', ENABLE_VALGRIND),
        ('ion', '', '--disable-ion', ENABLE_ION),
)

cfg = JS_ROOT + ' '

def get_yesno_answer(question, default=None):
    question_with_default = question
    if default is not None:
        question_with_default += ' (default: ' + default + ')'

    while True:
        try:
            rep = raw_input(question_with_default)
            if rep == 'y' or rep == 'Y':
                return True
            elif rep == 'n' or rep == 'N':
                return False
            elif len(rep) == 0 and default is not None:
                return default == 'y' or default == 'Y'
            else:
                raise Exception
            break
        except:
            print('Only possible answers are y or n')

for name, yes, no, default in options:
    if get_yesno_answer('Would you like to activate ' + name + '?', default):
        if len(yes) > 0:
            cfg += ' ' + yes
    else:
        if len(no) > 0:
            cfg += ' ' + no

env = os.environ
newEnvOptions = {}

def add_env_option(key, val):
    env[key] = val
    newEnvOptions[key] = val

if get_yesno_answer('use clang / clang++?', USE_CLANG):
    add_env_option('CC', '"clang"')
    add_env_option('CXX', '"clang++"')
    if get_yesno_answer('enable ASAN?', ENABLE_ASAN):
        add_env_option('CC', '"clang -fsanitize=address"')
        add_env_option('CXX', '"clang++ -fsanitize=address"')
        add_env_option('LDFLAGS', '"-fsanitize=address"')
        cfg += " --enable-address-sanitizer"
    elif get_yesno_answer('enable TSAN?', ENABLE_TSAN):
        add_env_option('CC', '"clang -fsanitize=thread -fPIC -pie"')
        add_env_option('CXX', '"clang++ -fsanitize=thread -fPIC -pie"')
        add_env_option('LDFLAGS', '"-fsanitize=thread -fPIC -pie"')
        cfg + " --enable-llvm-hacks --disable-jemalloc --disable-crashreporter --disable-elf-hack"
    elif get_yesno_answer('enable static analysis?', ENABLE_STATIC_ANALYSIS):
        print "Make sure to have installed libclang-dev and libedit-dev."
        cfg += " --enable-clang-plugin"
elif get_yesno_answer('32 bits builds?', COMPILE_32_BITS):
    add_env_option('CC', '"gcc -m32 -march=pentiumpro"')
    add_env_option('CXX', '"g++ -m32 -march=pentiumpro"')
    add_env_option('AR', '"ar"')
    cfg += " --target=i686-pc-linux"
    if get_yesno_answer('arm simulator build?', COMPILE_ARM_SIMULATOR):
        cfg += ' --enable-simulator=arm'
    elif get_yesno_answer('mips simulator build?', COMPILE_MIPS_SIMULATOR):
        cfg += ' --enable-simulator=mips'
else:
    if get_yesno_answer('arm64 simulator build?', COMPILE_ARM64_SIMULATOR):
        cfg += ' --enable-simulator=arm64'

envString = ' '.join(['%s=%s' % (k, newEnvOptions[k]) for k in newEnvOptions])
print envString + ' ' + cfg
while True:
    a = raw_input("Would you like to run it (r), save it (s), or quit (q) ?")
    if a == 'r':
        run_args = [arg for arg in cfg.split(' ') if len(arg) > 0]
        p = subprocess.Popen(run_args, stdout=subprocess.PIPE, env=env)
        print p.communicate()[0]
        break

    if a == 's':
        name = raw_input("Give it a name: (default: " + DEFAULT_BUILD_SCRIPT_NAME + ")")
        if len(name) == 0:
            name = DEFAULT_BUILD_SCRIPT_NAME

        HEADER = "#!/bin/bash\n"
        f = file(name, "w+")
        f.write(HEADER)
        f.write(envString + ' ' + cfg)
        os.chmod('./' + name, 0755)
        f.close()
        break
    if a == 'q':
        break
