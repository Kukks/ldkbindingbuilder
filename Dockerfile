# Use a base image with Fedora 39 and required dependencies
FROM fedora:39

# Install necessary packages
RUN dnf install -y mingw64-gcc git cargo dotnet clang llvm lld faketime rust-std-static-x86_64-pc-windows-gnu which diffutils mono-complete 

# Install cbindgen
RUN cargo install cbindgen

# Set the working directory
WORKDIR /app

# Copy the entrypoint script into the container
COPY docker-entrypoint.sh .
RUN echo "alias csc='mono-csc'" >> ~/.bashrc
# Set the entrypoint script as the entry point for the container
ENTRYPOINT ["/bin/bash", "docker-entrypoint.sh"]
