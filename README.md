The root of the experiments is [src/](src/). Here we use Docker to create a Linux development environment.

## Getting Started

1. The *Dockerfile* present in this directory describes the specific Docker image that we'll be using as our base. We need to build this image and give it a name (e.g. `linux-devbox`) by either entering this command or running `./build`:

  ```bash
  $ docker build -t linux-devbox .
  ```
2. Once the image is prepared, we run a container from it by entering the following command or running `./enter`:

  ```bash
  $ docker run -ti -v $(pwd)/src:/src linux-devbox
  ```

## Sources
* [devbox](https://github.com/hunan-rostomyan/devbox)
