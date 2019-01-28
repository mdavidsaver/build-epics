#!/bin/sh
set -e

IAM="$(readlink -f "$0")"

BASEDIR="$(dirname "$IAM")"

export EPICS_HOST_ARCH="$("$BASEDIR"/epics-base/startup/EpicsHostArch)"

# adjust RELEASE paths
for ff in "$BASEDIR"/*/configure/RELEASE "$BASEDIR"/*/*/configure/RELEASE
do
  echo "Adjust $ff"
  sed -i -e '/EPICS_BASE=/d' "$ff"
  cat <<EOF >> "$ff"
EPICS_BASE=$BASEDIR/epics-base
EOF
done

echo "Create $BASEDIR/eactivate"

cat <<EOF > "$BASEDIR"/eactivate
# source me to enable

_OLD_EPICS_PATH="\$PATH"

[ "\$EPICS_HOST_ARCH" ] || export EPICS_HOST_ARCH="$("$BASEDIR"/epics-base/startup/EpicsHostArch)"

# caget et al
export PATH=$BASEDIR/epics-base/bin/\$EPICS_HOST_ARCH:\$PATH

edeactivate() {
    PATH="\$_OLD_EPICS_PATH"
    unset _OLD_EPICS_PATH
    unset edeactivate
}
EOF

chmod -R a-w "$BASEDIR"

cat <<EOF
System package dependencies

  # Debian
  apt-get install build-essential libreadline6-dev libncurses5-dev perl libpcre3-dev re2c

  # RHEL/CentOS  w/ EPEL
  yum install gcc-c++ glibc-devel make readline-devel ncurses-devel perl-devel \\
   pkg-config pcre-devel re2c

To begin using run:
. $BASEDIR/eactivate
EOF
