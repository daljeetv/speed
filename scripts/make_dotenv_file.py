#!/usr/bin/env python

ORG = 'speed'
DOMAIN = ORG + '.com'
APP = 'speed-speed'
KEYS = ['PAPERTRAIL_API_TOKEN',
        'SUPERUSER_PASSWORD',
        'SUPERUSER_USERNAME' ]
KEYAMBLE = ['CLOUDAMQP', 'HEROKU'] # like a preamble but for keys

import argparse
import subprocess
import json
import os
import sys

def heroku_login(verbose):
    stdout = subprocess.check_output(['heroku', 'whoami'])
    if not stdout.rstrip().endswith(DOMAIN):
        if verbose:
            print('not logged in to {} heroku org'.format(ORG))
        stdout = subprocess.check_output(['HEROKU_ORGANIZATION=speed', 'heroku',
                                          'login', '--sso'])

def get_heroku_config(app, verbose):
    stdout = subprocess.check_output(['heroku', 'config', '--json', '-a', app])
    if verbose:
        print(stdout)
    j = json.loads(stdout)
    if verbose:
        print(j.keys())
    return(j)

def update_dictionary(env_dict, verbose):
    for (k, v) in sorted(env_dict.items()):
        if (k in KEYS or any([k.startswith(x) for x in KEYAMBLE])):
            env_dict.pop(k) # delete it from the dictionary
    env_dict['DATABASE_URL'] = '{}://{}:{}@{}/speed_development'.format(
        'postgres',
        os.getenv('PGUSER') or '',
        os.getenv('PGPASSWORD') or '',
        os.getenv('PGHOST') or 'localhost'
    )
    env_dict['ENVIRONMENT'] = 'development'
    env_dict['PORT'] = 5000

def write_env_file(env_dict, env_file, bash, verbose):
    if os.path.exists(env_file):
        print('env file exists, refusing to overwrite')
        sys.exit(1)
    with open(env_file, 'w') as f:
        if bash:
            for (k, v) in sorted(env_dict.items()):
                if '\n' in v:
                    line = "export {}=$'{}'\n".format(k, '\\n'.join(v.splitlines()))
                else:
                    line = "export {}='{}'\n".format(k, v)
                f.write(line)
        else:
            json.dump(
                env_dict, f, indent=2, sort_keys=True, separators=(',', ': ')
            )
            f.write('\n')
    print('wrote data to {}, please verify file'.format(env_file))

def main():
    ''' Creates a .env for local use based on `heroku config` '''
    parser = argparse.ArgumentParser()
    parser.add_argument('-a', '--app', default=APP,
                        help='heroku application name')
    parser.add_argument('-e', '--env_file', default='.env',
                        help='.env file name name')
    parser.add_argument('-b', '--bash', action='store_true', default=False,
                        help='write env file as bash script instead of JSON')
    parser.add_argument('-v', '--verbose', action='store_true', default=False,
                        help='show verbose output')
    args = parser.parse_args()
    heroku_login(args.verbose)
    env_dict = get_heroku_config(args.app, args.verbose)
    update_dictionary(env_dict, args.verbose)
    write_env_file(env_dict, args.env_file, args.bash, args.verbose)

if '__main__' == __name__:
    main()
