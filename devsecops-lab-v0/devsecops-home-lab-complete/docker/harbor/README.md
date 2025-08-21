Harbor installation notes:
1. Download Harbor installer from https://goharbor.io and copy the tar.gz to /opt/harbor on docker-node.
2. Extract, place harbor.yml (this template) in the installer folder, then run ./install.sh
3. After install:
   - Login to Harbor UI using admin/<password set in harbor.yml>
   - Create project 'demo'
   - Create a Robot account for Jenkins and store credentials in Jenkins
