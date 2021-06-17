#!/usr/bin/env bash
set -o errexit

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Generate a container image for the GCC toolchain with Buildah."
   echo
   echo "Syntax: gcc-image.sh [-a|h]"
   echo "options:"
   echo "a     Build for the specified target architecture, i.e. amd64, arm, arm64."
   echo "h     Print this Help."
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Set variables
ARCHITECTURE="$(podman info --format={{".Host.Arch"}})"

############################################################
# Process the input options. Add options as needed.        #
############################################################
while getopts ":a:h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      a) # Enter a target architecture
         ARCHITECTURE=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

CONTAINER=$(buildah from --arch "$ARCHITECTURE" registry.fedoraproject.org/fedora-minimal:latest)
IMAGE="gcc"

buildah run "$CONTAINER" /bin/sh -c 'microdnf install -y clang-tools-extra cmake gdb gcc gcc-c++ openocd ninja-build python3 python3-pip python3-wheel python-unversioned-command --nodocs --setopt install_weak_deps=0'

buildah run "$CONTAINER" /bin/sh -c 'microdnf clean all -y'

buildah run "$CONTAINER" /bin/sh -c 'python -m pip install conan'

buildah run "$CONTAINER" /bin/sh -c 'python -m pip install cmakelang[yaml]'

buildah run "$CONTAINER" /bin/sh -c 'python -m pip cache purge'

buildah run "$CONTAINER" /bin/sh -c 'useradd -ms /bin/bash user'

buildah config --user user "$CONTAINER"

buildah config --workingdir /home/user "$CONTAINER"

buildah config --author "jordan@jwillikers.com" "$CONTAINER"

buildah commit "$CONTAINER" "$IMAGE"

buildah rm "$CONTAINER"
