FROM alpine:3.15

#create 3 users: {sftp  wealth stacs}
RUN \
  adduser  -u 1000 -D sftp && \
  adduser  -u 1001 -D -G sftp biz  && \
  adduser  -u 1002 -D -G sftp wealth  && \
  adduser  -u 1003 -D -G sftp stacs && \
  passwd -u sftp; passwd -u biz ;passwd -u wealth ; passwd -u stacs

#set permissions
RUN sh -x &&\
  for user in "biz" "wealth" "stacs" ;\
  do \
    mkdir -p /home/${user}/.ssh && touch /home/${user}/.ssh/authorized_keys ;\
    chmod 700 /home/${user}/.ssh && chmod 600 /home/${user}/.ssh/authorized_keys && chown -R ${user}:sftp /home/${user}/.ssh ;\
  done 
#change alpine source
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories 


RUN \
  echo "**** install openssh ****" && \
  apk add --no-cache \
    logrotate \ 
    openssh-client\
    openssh-server-pam \
    openssh-sftp-server && \
  echo "**** setup openssh environment ****" && \
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config 

#change umask 
RUN sed -i 's/umask 022/umask 002/g'  /etc/profile

COPY start.sh  /

CMD ["sh","-c","/start.sh"]

EXPOSE 22
