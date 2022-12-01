# ace-vnc-devcontainer

Toolkit-enabled codespaces container for ACE v12

## Background

Codespaces are a [feature of GitHub](https://github.com/features/codespaces) that enables
container-based development with VisualStudio Code in a web browser. The container in
which vscode runs is configurable, and this repo uses a container with ACE installed.

Developers get sixty hours of container runtime for free (at the time of
writing), and a codespace can be launched from the "Code" menu:

![Codespaces launch](/files/codespaces-launch.png)

ACE v12 can be run in a codespace using containers from [ace-docker](https://github.com/trevor-dolby-at-ibm-com/ace-docker/tree/main/experimental/devcontainers)
but those containers are intended for command-line use in conjunction with vscode. This
container allows the use of the toolkit without any need to install anything locally.

The main additions are
- An X-Windows server to be used by the toolkit GUI
- A VNC server that allows VNC clients to access the X-Windows desktop
- A VNC client that runs in a browser and can connect to the VNC server

## Building

The container should be built using the ACE developer edition and pushed to a public 
repository; there are containers under tdolby/experimental on dockerhub but these should
not be relied upon to stay around and/or work at all.

```
docker build -t ace-devcontainer-xvnc:12.0.4.0 -f Dockerfile.xvnc .
```
followed by tagging and pushing the container. The resulting public image tag should be 
used in the configuration below instead of the experimental image shown.

## Application repo setup

Codespace configurations are held in the .devcontainer directory of the repo containing
the ACE projects rather than being configured in a separate repo. These instructions will
use the example at https://github.com/tdolby-at-uk-ibm-com/ace-bdd-cucumber to illustrate
usage.

The [devcontainer.json](https://github.com/tdolby-at-uk-ibm-com/ace-bdd-cucumber/blob/main/.devcontainer/devcontainer.json)
file should contain something like 
```
{
    "name": "ace-bdd-cucumber-devcontainer",
    "image": "tdolby/experimental:ace-devcontainer-xvnc-12.0.7.0",
    "containerEnv": {
        "LICENSE": "accept"
    },
    "remoteEnv": {
        "REMOTE_LICENSE": "accept"
    }
}
```
to instruct the codespaces runtime to load the `tdolby/experimental:ace-devcontainer-xvnc-12.0.7.0` container
(the name should be changed to match the container built earlier (see above)) and the license must be accepted 
for the product to work correctly.

## Starting the toolkit

Once the application repo is set up correctly, it should be possible to launch the codespace container from
the "code" menu (see picture above) and start it downloading the image; this may take some
time, and clicking on "view logs" should show something like

![Codespaces startup](/files/vnc-codespace-setting-up.png)

Once the container is up and running, the ACE command line will be available as usual in the terminal window
so commands like `mqsilist` will run as expected. Running the toolkit takes a few more steps, starting with
launching X-Windows and VNC servers using the `run-vnc.sh` script:

![server startup](/files/vnc-codespace-start-xvnc.png)

Enter a password at the prompt, say "no" the the view-only password, and the server should then start in the
background. A pop-up is likely to appear stating that a server is listening on port 5901, but this is not the
port we need to use and so instead the "PORTS" tab should be selected so that we can select port 6080 and 
follow the link in the browser:

![server startup](/files/vnc-codespace-port-6080.png)

This page is a directory, and the `vnc.html` page is the one we need to gain access to VNC:

![vnc page](/files/vnc-codespace-vnc-html.png)

This page will have a "connect" button which will connect to the VNC server, at which point the password
entered earlier will be needed to access the virtual X-Windows desktop. Right-clicking on the background
will allow a terminal to be launched, and the ACE product is in /opt/ibm/ace-12 so running

```
/opt/ibm/ace-12/ace tools
```
will bring up the toolkit.

## Importing the projects

The toolkit will not have any projects visible by default, as these are in the codespaces-provided /workspaces
directory rather than in an Eclipse workspace. The projects need to be imported without copying, as the goal
is to allow git to push changes back to the repo without any further setup (as normally happens with vscode).

Right-clicking on the white background of the "Application Devleopment" pain shows the "import" option

![vnc page](/files/vnc-codespace-import-select.png)

which leads to the import wizard page where "Existing projects into Workspace" is the correct choice:

![vnc page](/files/vnc-codespace-import-existing.png)

The correct location is the repo directory under /workspaces:

![vnc page](/files/vnc-codespace-import-location.png)

and after the import is complete then the projects should work as they do on a local system: test projects
can be run, changes made to flows and code, etc.

Changes made in the toolkit should appear in the git perspective and can be pushed to the repo from the 
toolkit or from the vscode editor (or the git command line).
