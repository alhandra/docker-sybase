# Dockerfile for sybase server

# docker build -t sybase .


FROM centos:7

MAINTAINER Tuan Vo <vohungtuan@gmail.com>

# Adding resources

## SAP ASE Developer Edition 
## https://go.sap.com/cmp/syb/crm-xu15-int-asewindm/typ.html
# http://d1cuw2q49dpd0p.cloudfront.net/ASE16.0/Linux16SP02/ASE_Suite.linuxamd64.tgz
# http://d1cuw2q49dpd0p.cloudfront.net/ASE16.0/Windows16SP02/ASE_Suite.winx64.zip

## SAP ASE Express Edition
# http://d1cuw2q49dpd0p.cloudfront.net/ASE16.0/ExpressEdition/ase160_linuxx86-64.zip
# http://d1cuw2q49dpd0p.cloudfront.net/ASE16.0/DeveloperEdition/ase160_winx64.zip

# Docker docs
# If <src> is a local tar archive in a recognized compression format (identity, gzip, bzip2 or xz) then it is unpacked as a directory.
# Resources from remote URLs are not decompressed.
# Because image size matters, using ADD to fetch packages from remote URLs is strongly discouraged; you should use curl or wget instead.

# ADD http://d1cuw2q49dpd0p.cloudfront.net/ASE16.0/Linux16SP02/ASE_Suite.linuxamd64.tgz /opt/tmp/
RUN set -x \
 && mkdir -p /opt/tmp/ 

COPY assets/* /opt/tmp/

WORKDIR  /opt/tmp

RUN tar xfz ASE_Suite.linuxamd64.tgz -C /opt/tmp/ 

# Setting kernel.shmmax and 
RUN set -x \
 && cp /opt/tmp/sysctl.conf /etc/ \
 && true || /sbin/sysctl -p

# see https://launchpad.support.sap.com/#/notes/2489781
# Installing Sybase RPMs
RUN set -x && yum clean all
RUN set -x && yum install -y unzip 
RUN set -x && yum install -y libpng12
RUN set -x && yum install -y libjpeg
RUN set -x && yum install -y libXft
RUN set -x && yum install -y libXp
RUN set -x && yum install -y libXt 
RUN set -x && yum install -y libXtst
RUN set -x && yum install -y libXi
RUN set -x && yum install -y libXmu
RUN set -x && yum install -y libXext
RUN set -x && yum install -y libSM
RUN set -x && yum install -y libICE
RUN set -x && yum install -y libX11
RUN set -x && yum install -y openmotif
RUN set -x && yum install -y libaio


# the response file was created for a specific hostname, lets replace by the correct one
RUN sed -i -e "s/REPLACE_BY_HOSTNAME/`hostname`/g" /opt/tmp/sybase-response.txt

# Install Sybase and create test instance and backup server
RUN set -x \
 && /opt/tmp/setup.bin -f /opt/tmp/sybase-response.txt \
    -i silent \
    -DAGREE_TO_SAP_LICENSE=true \
    -DRUN_SILENT=true

# Change the Sybase interface
# Set the Sybase startup script in entrypoint.sh

#RUN mv /opt/sybase/interfaces /opt/sybase/interfaces.backup \
# && cp /opt/tmp/interfaces /opt/sybase/ \
# && cp /opt/tmp/sybase-entrypoint.sh /usr/local/bin/ \
# && chmod +x /usr/local/bin/sybase-entrypoint.sh \
# && ln -s /usr/local/bin/sybase-entrypoint.sh /sybase-entrypoint.sh

RUN cp /opt/tmp/sybase-entrypoint.sh /usr/local/bin/ \
     && chmod +x /usr/local/bin/sybase-entrypoint.sh \
 && ln -s /usr/local/bin/sybase-entrypoint.sh /sybase-entrypoint.sh


# Setup the ENV
# https://docs.docker.com/engine/reference/builder/#run
# RUN ["/bin/bash", "-c", "source /opt/sybase/SYBASE.sh"]

ENTRYPOINT ["/sybase-entrypoint.sh"]

# CMD []

EXPOSE 5000

# Remove tmp
RUN find /opt/tmp/ -type f | xargs -L1 rm -f

# Share the Sybase data directory
#VOLUME ["/opt/sybase/data"]

# When run it
# docker run -d -p 8000:5000 -p 8001:5001 --name my-sybase sybase