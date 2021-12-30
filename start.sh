#!/bin/sh
if [ ! -L /etc/ssh ];then
    if [ ! -f /data/ssh/sshd_config ]; then
        ssh-keygen -A
        cp -a /etc/ssh /data/ssh
        chmod 750 /data/ssh
    fi
    rm -Rf /etc/ssh    
    ln -s /data/ssh /etc/ssh
fi

[[ -n "$BIZ_PUBLIC_KEY" ]] && \
    [[ ! $(grep "$BIZ_PUBLIC_KEY"  /home/biz/.ssh/authorized_keys) ]] && \
    echo "$BIZ_PUBLIC_KEY" >> /home/biz/.ssh/authorized_keys && \
    chown -R biz:sftp /home/biz/.ssh/authorized_keys && chmod 600 /home/biz/.ssh/authorized_keys \
    echo "Public key from env variable added for BIZ"
[[ -n "$WEALTH_PUBLIC_KEY" ]] && \
    [[ ! $(grep "$WEALTH_PUBLIC_KEY" /home/wealth/.ssh/authorized_keys) ]] && \
    echo "$WEALTH_PUBLIC_KEY" >> /home/wealth/.ssh/authorized_keys && \
    chown -R wealth:sftp /home/wealth/.ssh/authorized_keys && chmod 600 /home/wealth/.ssh/authorized_keys \
    echo "Public key from env variable added for WEALTH"
[[ -n "$STACS_PUBLIC_KEY" ]] && \
    [[ ! $(grep "$STACS_PUBLIC_KEY" /home/stacs/.ssh/authorized_keys) ]] && \
    echo "$STACS_PUBLIC_KEY" >> /home/stacs/.ssh/authorized_keys && \
    chown -R stacs:sftp /home/stacs/.ssh/authorized_keys && chmod 600 /home/stacs/.ssh/authorized_keys \
    echo "Public key from env variable added for STACS"  

exec /usr/sbin/sshd.pam -D -e "$@"