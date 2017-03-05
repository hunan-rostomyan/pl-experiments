FROM lepinkainen/ubuntu-python-base:latest

# Utilities
RUN apt-get -qq update
RUN apt-get install -y tree
RUN apt-get install -y vim
RUN apt-get install -y libmozjs-24-bin

# CD into it the source directory
WORKDIR /src

# Shell configuration
COPY config/.bashrc /root/

# Run the shell
CMD ["/bin/bash"]
