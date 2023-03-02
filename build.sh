#!/bin/bash

if [ -z $1 ]; then
    echo "Building parent module..."
    ant
    echo "Done"
else
    build_cmd=None
    case $1 in
        "demo")
            btypes="demo"
            ;;
        "docker")
            btypes="docs timer main"
            dockerImage="yes"
            if command -v buildah &> /dev/null; then
                build_cmd="buildah bud -t derbynet_server -f installer/docker/Dockerfile ."
            elif command -v podman &> /dev/null; then
                build_cmd="podman build -t derbynet_server -f installer/docker/Dockerfile ."
            elif command -v docker &> /dev/null; then
                build_cmd="docker build -t derbynet_server -f installer/docker/Dockerfile ."
            fi
            ;;
        "debian")
            btypes="installer/debian"
            ;;
        "all")
            btypes="docs timer installer/debian demo main"
            ;;
        *)
            echo "Unknown build type"
            exit 1
            ;;
    esac
fi

for btype in ${btypes}; do
    if [ "$btype" = "main" ]; then
        echo "Building parent module..."
        ant
    else
        echo "Building $(basename ${btype}) module..."
        pushd ${btype} >/dev/null 2>&1
        ant
        popd >/dev/null 2>&1
    fi
    echo "Done"
done

if [ -n "${dockerImage}" ]; then
    echo "Building docker image..."
    echo "${build_cmd}"
    ${build_cmd}
    echo "Done"
fi