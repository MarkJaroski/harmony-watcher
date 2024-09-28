# harmony-watcher

This little script watches a the websocket on a harmony hub for activity
starts, and when appropriate changes the autologin user and restarts GDM.

It depends on https://github.com/vi/websocat

This is quicker and more robust than programming the harmony hub to login
with a given username and password.

To use this script edit it with values from your harmony hub and copy it to
/usr/local/sbin then copy the systemd service file to
/etc/systemd/services/ enable it and run it.

