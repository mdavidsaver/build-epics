Relocatable EPICS environment

After unpacking 'prepare.sh' be run to create a file 'eactivate'
which can be sourced each time to update $PATH.  "edeactivate"
will attempt to restore the original environment.


One time setup

  $ ./prepare.sh

Each time

  $ . eactivate


Demo

  $ which softIoc
  /path/to/epics-x86_64-20181213/epics-base/bin/linux-x86_64/softIoc
  $ softIoc -m P=`whoami`: -d demo.db

