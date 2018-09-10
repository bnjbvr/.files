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
USE_CLANG = 'y'
CROSS_COMPILE_ARM = 'n'
CROSS_COMPILE_ARM_HF = 'y'
COMPILE_32_BITS = 'n'
COMPILE_ARM_SIMULATOR = 'n' # needs COMPILE_32_BITS to be 'y' if you want to set as 'y'
COMPILE_ARM64_SIMULATOR = 'n' # needs COMPILE_32_BITS to be 'n' if you want to set as 'y'
COMPILE_MIPS32_SIMULATOR = 'n' # needs COMPILE_32_BITS to be 'y' if you want to set as 'y'
COMPILE_MIPS64_SIMULATOR = 'n' # needs COMPILE_32_BITS to be 'n' if you want to set as 'y'
ENABLE_DEBUG = 'y'
ENABLE_OPTIMIZE = 'n'
ENABLE_CCACHE = 'y'
ENABLE_INTL = 'n'
ENABLE_PERF = 'n'
ENABLE_TRACELOGGING = 'n'
ENABLE_THREAD_SAFETY = 'y'
ENABLE_ASAN = 'n'
ENABLE_TSAN = 'n'
ENABLE_MSAN = 'n'
ENABLE_VALGRIND = 'n'
ENABLE_ION = 'y'
ENABLE_STATIC_ANALYSIS = 'n'
ENABLE_COMPILEDB = 'y'
ENABLE_WARNINGS_AS_ERRORS = 'y'

DEFAULT_BUILD_SCRIPT_NAME = 'build.sh'

# Enjoy
PATH_TO_JS_CONFIGURE= '/js/src/configure'
AVAILABLE_ROOTS = [BASE_ROOTS + v + PATH_TO_JS_CONFIGURE for v in AVAILABLE_VARIANTS]

if COMPILE_ARM_SIMULATOR != COMPILE_32_BITS:
    COMPILE_ARM_SIMULATOR = 'n'
if COMPILE_MIPS32_SIMULATOR != COMPILE_32_BITS:
    COMPILE_MIPS32_SIMULATOR = 'n'
if COMPILE_ARM64_SIMULATOR == COMPILE_32_BITS:
    COMPILE_ARM64_SIMULATOR = 'n'
if COMPILE_MIPS64_SIMULATOR == COMPILE_32_BITS:
    COMPILE_MIPS64_SIMULATOR = 'n'

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
        try:
            root = raw_input('Choose your root: (default=0)')
            if len(root) == 0:
                root = 0
            root = int(root)
            if root < len(AVAILABLE_ROOTS):
                root = AVAILABLE_ROOTS[root]
                if root is not None:
                    break
            print 'there is no such available root'
        except KeyboardInterrupt:
            print("Aborting, bye!")
            exit(0)
        except:
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
    ('warnings as errors', '--enable-warnings-as-errors', ENABLE_WARNINGS_AS_ERRORS)
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
            if rep == 'n' or rep == 'N':
                return False
            if len(rep) == 0 and default is not None:
                return default == 'y' or default == 'Y'
            raise Exception
        except KeyboardInterrupt:
            print("Aborting, bye!")
            exit(0)
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
overridenEnv = {}
did_cross_compile = False

def add_env_option(key, val):
    env[key] = val
    assert key not in overridenEnv
    overridenEnv[key] = val

if get_yesno_answer('use clang / clang++?', USE_CLANG):
    add_env_option('CC', '"clang"')
    add_env_option('CXX', '"clang++"')
    cfg += " --enable-linker=lld"

    if get_yesno_answer('enable ASAN?', ENABLE_ASAN):
        add_env_option('CC', '"clang -fsanitize=address"')
        add_env_option('CXX', '"clang++ -fsanitize=address"')
        add_env_option('LDFLAGS', '"-fsanitize=address"')
        cfg += " --enable-address-sanitizer --disable-jemalloc"
    elif get_yesno_answer('enable TSAN?', ENABLE_TSAN):
        add_env_option('CC', '"clang -fsanitize=thread -fPIC -pie"')
        add_env_option('CXX', '"clang++ -fsanitize=thread -fPIC -pie"')
        add_env_option('LDFLAGS', '"-fsanitize=thread -fPIC -pie"')
        cfg + " --enable-llvm-hacks --disable-jemalloc --disable-crashreporter --disable-elf-hack"

    if get_yesno_answer('enable MSAN?', ENABLE_MSAN):
        add_env_option('CC', '"clang -fsanitize=memory"')
        add_env_option('CXX', '"clang++ -fsanitize=memory"')
        add_env_option('LDFLAGS', '"-fsanitize=memory"')
        cfg += " --enable-memory-sanitizer --disable-jemalloc"
    elif get_yesno_answer('enable static analysis?', ENABLE_STATIC_ANALYSIS):
        print "Make sure to have installed libclang-dev and libedit-dev."
        cfg += " --enable-clang-plugin"

    if get_yesno_answer('emit compile_commands.json at compilation?', ENABLE_COMPILEDB):
        cfg += " --enable-build-backends=CompileDB,RecursiveMake "

elif get_yesno_answer('ARM cross compilation?', CROSS_COMPILE_ARM):
    print "Make sure to have installed gcc-arm-linux-gnueabi{,hf} g++-arm-linux-gnueabi{,hf} binutils-arm-linux-gnueabi{,hf}"
    if get_yesno_answer('hard float ABI?', CROSS_COMPILE_ARM_HF):
        cc = '"arm-linux-gnueabihf-gcc"'
        cxx = '"arm-linux-gnueabihf-g++"'
        ar = '"arm-linux-gnueabihf-ar"'
        target = ' --target=arm-linux-gnueabihf'
    else:
        cc = '"arm-linux-gnueabi-gcc"'
        cxx = '"arm-linux-gnueabi-g++"'
        ar = '"arm-linux-gnueabi-ar"'
        target = ' --target=arm-linux-gnueabi'

    add_env_option('CC', cc)
    add_env_option('CXX', cxx)
    add_env_option('AR', ar)
    cfg += target

    did_cross_compile = True

# Fantastic simulators, and where to find them!
if not did_cross_compile:
    if get_yesno_answer('32 bits builds?', COMPILE_32_BITS):
        add_env_option('CCFLAGS', '"-m32 -msse -msse2 -mfpmath=sse"')
        add_env_option('CXXFLAGS', '"-m32  -msse -msse2 -mfpmath=sse"')
        add_env_option('AR', '"ar"')
        cfg += " --target=i686-pc-linux"
        cfg += " --host=i686-pc-linux"
        if get_yesno_answer('arm simulator build?', COMPILE_ARM_SIMULATOR):
            cfg += ' --enable-simulator=arm'
        elif get_yesno_answer('mips simulator build?', COMPILE_MIPS32_SIMULATOR):
            cfg += ' --enable-simulator=mips32'
    elif get_yesno_answer('arm64 simulator build?', COMPILE_ARM64_SIMULATOR):
        cfg += ' --enable-simulator=arm64'
    elif get_yesno_answer('mips64 simulator build?', COMPILE_MIPS64_SIMULATOR):
        cfg += ' --enable-simulator=mips64'

overridenEnvString = ' '.join(['%s=%s' % (k, overridenEnv[k]) for k in overridenEnv])
print overridenEnvString + ' ' + cfg
while True:
    try:
        a = raw_input("Would you like to run it (r), save it (s), or quit (q) ?")

        if a == 'r':
            run_args = [arg for arg in cfg.split(' ') if len(arg) > 0]
            p = subprocess.Popen(run_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=env)
            stdout, stderr = p.communicate()
            print "STDOUT=", stdout
            print "STDERR=", stderr
            break

        if a == 's':
            name = raw_input("Give it a name: (default: " + DEFAULT_BUILD_SCRIPT_NAME + ")")
            if len(name) == 0:
                name = DEFAULT_BUILD_SCRIPT_NAME

            content = "#!/bin/bash\n"
            content += ' \\\n'.join(['%s=%s' % (k, overridenEnv[k]) for k in overridenEnv])
            content += ' \\\n'
            content += ' \\\n    '.join([x for x in cfg.split(' ') if len(x) > 0])
            content += '\n'

            with file(name, "w+") as f:
                f.write(content)
            os.chmod('./' + name, 0755)
            break

        if a == 'q':
            break

        print("Only valid options are r/s/q, please retry.")
    except KeyboardInterrupt:
        print("Aborting, bye!")
        exit(0)
