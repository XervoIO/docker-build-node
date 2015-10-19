# Modulus Node.js Docker Build Image
The Modulus images are a set of Docker images designed to run arbitrary applications with a standardized external interface. The Modulus image convention enforces a high degree of security and control required by PaaS environments and might not be suitable for small, more focused, deployments.

Refer to the [base build image](https://github.com/onmodulus/docker-build-base) for details on how all Modulus Run Images work.

## Image Details
The Modulus Node.js build image supports running any version of Node.js and npm handles initializing the correct versions as part of its build process. The node version can be defined in the app bundle's package.json or app.json files. If no version is specified the most recent stable version of Node.js and npm is used.

## How to use this image
All Modulus images enforce a strict data convention for security and ease of orchestration. Application source should be mounted in externally and assumptions are made based on these directories.

``` text
/host-folder/
  |- tmp/
  |- home/
  |- input/
  |- output/
```

The only requirement for a basic running container is to put the fully extracted application source into the input folder. Then mount this directory to /mnt inside the container and run the build executable.

``` text
$ docker pull onmodulus/build-node
$ docker run -v /host-folder:/mnt -p 80:8080 onmodulus/build-node build
```

All Modulus build images have a binary available in the PATH named `build` that is a script designed to run the build process. The build script in the Node.js run image handles initializing the proper version of Node.js, npm, and then executes the npm install process. All output of the build process is placed in /mnt/output.

# License
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
