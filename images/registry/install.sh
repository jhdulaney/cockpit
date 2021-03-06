#!/bin/sh

set -ex

# Install packages without dependencies
if [ -z "$VERSION" ]; then
    eval $(/container/scripts/get-version-env.sh)
fi

/container/scripts/install-rpms.sh -a noarch --nodeps cockpit-shell-
/container/scripts/install-rpms.sh --nodeps cockpit-ws-  cockpit-kubernetes-

# Remove unwanted packages
rm -rf /usr/share/cockpit/realmd/ /usr/share/cockpit/system/ /usr/share/cockpit/tuned/ /usr/share/cockpit/users/ /usr/share/cockpit/dashboard/ /usr/share/cockpit/kubernetes

echo "{
    \"version\": 0,

    \"dashboard\": {
        \"index\": {
            \"label\": \"Image Registry\",
            \"order\": 3
        }
    }
}" > /usr/share/cockpit/registry/manifest.json

ln -sf /container/branding /usr/share/cockpit/branding/cockpit-kubernetes

rm -rf /container/scripts
rm -rf /container/rpms

# Openshift will change the user
# but it will be part of gid 0
# so make the files we need group writable
rm -rf /etc/cockpit/
mkdir -p /etc/cockpit/
chmod 775 /etc
chmod 775 /etc/cockpit
chmod 775 /etc/os-release
chmod 775 /usr/share/cockpit/shell
