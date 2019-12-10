# Docker Sybase ASE image

[![Build Status](https://travis-ci.org/nguoianphu/docker-sybase.svg?branch=master)](https://travis-ci.org/nguoianphu/docker-sybase)
[![](https://images.microbadger.com/badges/image/nguoianphu/docker-sybase.svg)](http://microbadger.com/images/nguoianphu/docker-sybase "Get your own image badge on microbadger.com")


## SAP ASE Express Edition
        https://www.sap.com/cmp/syb/crm-xu15-int-asexprdm/index.html 

## This image use the SAP Express Edition

### BEFORE YOU BUILD
        1) You should download ASE express edition yourself.
        2) copy the resulting file ASE_Suite.linuxamd64.tgz to the assets directory
        
### Build

        docker build -t sybase .
        
### Run
        docker run -d -p 8000:5000 -p 8001:5001 --name my-sybase sybase
        
        # or
        docker run -d -p 8000:5000 -p 8001:5001 --name nguoianphu-sybase nguoianphu/docker-sybase
        
#### Check isql

        docker exec -it my-sybase /bin/bash
        
        source /opt/sybase/SYBASE.sh
        isql -U sa -P myPassword -S MYSYBASE
        
        select @@version
        go
        
### Mount licenses

        docker run -d -p 8000:5000 -p 8001:5001 -v /path/to/sybase_licenses:/opt/sybase/SYSAM-2_0/licenses --name my-sybase sybase
        
        # or
        docker run -d -p 8000:5000 -p 8001:5001 -v /path/to/sybase_licenses:/opt/sybase/SYSAM-2_0/licenses --name nguoianphu-sybase nguoianphu/docker-sybase