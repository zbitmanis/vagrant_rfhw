#!/usr/bin/env python


"""
   Copyright 2017 Andris Zbitkovskis

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
"""
import math
import argparse
import daemon
import signal 
import logging

from daemon import pidfile 
from sleeper import Sleeper

debug =True


def start_daemon(pidf,  workd,  fork ,amqp_url):
    global debug
    interactive =  not fork  in ['y', 'Y']
    LOG_FILE='/var/log/sleeper/daemon.log'
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG if debug else logging.INFO)
    fmt = logging.Formatter("%(asctime)s %(levelname)s %(message)s","%Y-%m-%d %H:%M:%S")
    fh = logging.StreamHandler() if interactive else logging.FileHandler(LOG_FILE) 
    fh.setFormatter(fmt)
    logger.addHandler(fh)
    sleeper = Sleeper( logger,amqp_url= amqp_url)
    if not interactive :
        if debug:
            print("sleeper: entered run()")
            print("sleeper: about to start daemonization")
        sleeper.daemon=True
        ctx=daemon.DaemonContext(
            working_directory=workd ,
            umask=0o002,
            pidfile=pidfile.TimeoutPIDLockFile(pidf),
            )
        ctx.signal_map = {
            signal.SIGHUP: 'terminate',
            }
        ctx.stdout=fh.stream 
        ctx.stderr=fh.stream 
        with ctx:
               sleeper.run()
    else:
        sleeper.run()
        
 

def main(argv):
   pass 

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="sleeping daemon")
    parser.add_argument('-p', '--pid-file', default='/var/run/sleeper/sleeper.pid')
    parser.add_argument('-w', '--working-dir', default='/tmp')
    parser.add_argument('-f', '--fork', choices=['y','n'] , default='y',  help='Fork' )
    args = parser.parse_args()
    host='central'
    user= 'guest'
    password= 'guest'
    amqp_url="amqp://{}:{}@{}:5672/%2F".format(user, password, host)
    start_daemon(pidf=args.pid_file,workd = args.working_dir , fork=args.fork , amqp_url=amqp_url)



