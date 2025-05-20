# ace-full-xvnc

Experimental toolkit-enabled container for ACE v12/v13 in containers

## Background

Similar to the main codespaces devcontainer, the `ace-full-xvnc` image contains
the full ACE product along with the other components needed to run the toolkit:

- An X-Windows server to be used by the toolkit GUI
- A VNC server that allows VNC clients to access the X-Windows desktop
- A VNC client that runs in a browser and can connect to the VNC server

![Overview](/files/ace-full-diagram.png)

This container does not depend on codespaces or any other infrastructure.

## Building

Can be built and pushed manually:
```
docker build --build-arg DOWNLOAD_URL=https://URL/FOR/13.0.3.0-ACE-LINUX64-EVALUATION.tar.gz -t ace-full-xvnc:13.0.3 -f Dockerfile.ace-full-xvnc .
```
followed by tagging and pushing the container. The resulting public image tag should be 
used in the configuration below instead of the experimental image shown.

Note that later versions are available; see https://github.com/trevor-dolby-at-ibm-com/ace-docker/tree/main/experimental#setting-the-correct-product-url
for instructions on how to find the URL if the public site has not been updated. Use the
resulting URL to update the image tag in `ace-full-xvnc-deployment.yaml` before deployment.

## Starting the container

The container needs the LICENSE, VNCPASSWORD, and HOME env vars set, and can be
deployed using the deployment YAML in this repo:
```
kubectl apply -f ace-full-xvnc-deployment.yaml
```
If persistent storage is needed, then customize `ace-full-xvnc-pvc.yaml`, apply it,
and then uncomment the volume sections in the deployment YAML.

## Accessing the web server

The web server does not currently impose any access controls, so the most secure
way to access the server is to use port forwarding:
```
kubectl --namespace cp4i port-forward ace-full-xvnc-bff85c888-x5bn4 6080:6080
```
using the pod name started by the deployment. 

(future enhancement: add a service to avoid having to use the pod name)

## Starting the toolkit

Once the container is started, it should be running a web server on port 6080
that can be used to access the X-Windows desktop. The port 6080 default page 
is a directory, and the `vnc.html` page is the one we need to gain access to VNC:

![vnc page](/files/vnc-codespace-vnc-html.png)

This page will have a "connect" button which will connect to the VNC server, at 
which point the password entered earlier will be needed to access the virtual 
X-Windows desktop. There should be a terminal running already (right-clicking on
the background will allow a terminal to be launched if not), and the ACE product
is in /opt/ibm/ace-13 so running
```
/opt/ibm/ace-13/ace tools
```
will bring up the toolkit.

## Further notes

ACE runs as normal in the container, so unit testing works as usual; integration
testing is also possible, and credentials can be mounted into the container from
Kubernetes secrets if needed.

The ACE v13 toolkit can push BAR files to the CP4i dashboard using the standard
API URL for the dashboard plus any needed user/pw credentials.
