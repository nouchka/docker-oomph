# docker-oomph
Eclipse setup using oomph in a docker container

Lighttpd make setup files available. Mount your own files.

2 volumes, one for the installer and one for eclipses.

Extends nouchka/oomph:latest with your own packages to have the right env.


# Checklist

+   format on save for php project
+   git working on repositories
+   auto-deriv files auto-set
+   show whitespaces, line number
+   disable auto-ignore file

# TODO
+   mount sub-directory of volume (docker issue)
+   user check right of volumes
+   create volume / network
+   delete test volume
+   push to docker hub
