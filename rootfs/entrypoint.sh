#!/usr/bin/env bash

getDockerSocketGroup () {
	echo "$(ls -al /var/run/docker.sock | awk '{print $4}')"
}

# Display the container banner
cat /banner

# Run scripts in /etc/entrypoint.d
for file in $( find /etc/entrypoint.d/ -name '*.sh' -type f | sort -u ); do
    [ -x "${file}" ] && sudo bash "${file}"
done

# Change docker socket user
echo ''
echo "***** docker-socket *****"
echo "Current user: $(whoami)"
echo "/var/run/docker.sock is currently in group:" $(getDockerSocketGroup)
echo "Changing group of docker.sock to: $DOCKER_GROUP"
sudo chown :$DOCKER_GROUP /var/run/docker.sock
echo "/var/run/docker.sock is now in group:" $(getDockerSocketGroup)
echo "*************************"
echo ''

# Running jenkins
exec /sbin/tini -- /usr/local/bin/jenkins.sh
