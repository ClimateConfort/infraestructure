# Use the specified base image
FROM debian:bookworm-20240211-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    default-jdk \
    maven \
    rabbitmq-server \
    openssh-server \
    sudo \
    curl \
    gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy Java projects into the Docker image
COPY java-projects /root/java-projects

# Enable RabbitMQ management plugin
RUN rabbitmq-plugins enable rabbitmq_management

# Create SSH directory and add public key
ARG ssh_public_key=gakoa.pub

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
COPY $ssh_public_key /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Expose ports for SSH and RabbitMQ
EXPOSE 22 5672 15672

# Start SSH and RabbitMQ services
CMD service ssh start && /usr/sbin/rabbitmq-server

