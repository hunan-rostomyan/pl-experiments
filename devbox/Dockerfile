FROM lepinkainen/ubuntu-python-base:latest

# Utilities
RUN apt-get install -y tree
RUN apt-get install -y vim

# CD into it the shared directory
WORKDIR /shared

# Shell configuration
COPY config/.bashrc /root/

# Run the shell
CMD ["/bin/bash"]
