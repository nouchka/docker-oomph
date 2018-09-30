#!/bin/bash

[ $PROJECT ] || exit 1

mkdir -p /home/developer/workspace/$PROJECT/

if [ "$WAKATIME_KEY" ]; then
	cat > /home/developer/.wakatime.cfg <<EOF
[settings]
api_key = $WAKATIME_KEY
debug = false
EOF
fi

if [ "$ECLIPSE_VERSION" ]; then
	if [ -d "/home/developer/eclipse/$ECLIPSE_VERSION" ]; then
		/home/developer/eclipse/$ECLIPSE_VERSION/eclipse/eclipse -nosplash -DLC_CTYPE=UTF-8 -Dfile.encoding=UTF-8
		exit 0
	else
		echo "$ECLIPSE_VERSION not present in /home/developer/eclipse/ launching installer"
	fi
	
fi
##-Doomph.redirection.setups=http://git.eclipse.org/c/oomph/org.eclipse.oomph.git/plain/setups/->setups/
/opt/eclipse-installer/eclipse-inst -vmargs "-Doomph.redirection.setups=http://git.eclipse.org/c/oomph/org.eclipse.oomph.git/plain/setups/->$SETUP_URL"
