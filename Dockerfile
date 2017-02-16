FROM lepinkainen/ubuntu-python-base:latest

# Utilities
RUN apt-get install -y tree
RUN apt-get install -y vim

# CD into it the source directory
WORKDIR /src

# Shell configuration
COPY config/.bashrc /root/

# Run the shell
CMD ["/bin/bash"]
