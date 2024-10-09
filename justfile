container:
    podman build --tag=ghcr.io/jdmarble/dosboxbox:latest .

push: container
    podman push ghcr.io/jdmarble/dosboxbox:latest

_tempdirs:
    mkdir -p output
    mkdir -p cache/rpmmd

image type: container _tempdirs
    podman run \
        --rm \
        --interactive \
        --tty \
        --privileged \
        --pull=newer \
        --security-opt label=type:unconfined_t \
        -v $(pwd)/config.toml:/config.toml \
        -v $(pwd)/output:/output \
        -v $(pwd)/cache/rpmmd:/rpmmd \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        quay.io/centos-bootc/bootc-image-builder:latest \
        --type {{type}} \
        --rootfs xfs \
        --local \
        ghcr.io/jdmarble/dosboxbox:latest

anaconda-iso: (image "anaconda-iso")
raw: (image "raw")
qcow2: (image "qcow2")

qemu-test: qcow2
    qemu-system-x86_64 \
        -M accel=hvf \
        -cpu host \
        -smp 2 \
        -m 2048 \
        -serial stdio \
        -snapshot output/qcow2/disk.qcow2
