#!/bin/bash

cat > /home/developer/.wakatime.cfg <<EOF
[settings]
api_key = $WAKATIME_KEY
debug = false
EOF

/opt/eclipse-installer/eclipse-inst -vmargs "-Doomph.redirection.setups=http://git.eclipse.org/c/oomph/org.eclipse.oomph.git/plain/setups/->http://setup/"
