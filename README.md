# Project Title: Gleam Fullstack

## One-line Tagline:
A full-stack application built with Gleam, a functional programming language for the Erlang VM, and Docker for containerization.

## Architecture Overview:

The `gleamfullstack` repository is structured into three main components: `client`, `server`, and `shared`. Each component serves distinct roles in the application's architecture:

- **Client**: Contains the frontend logic written in Gleam. It includes HTML files, JavaScript (compiled from Gleam), and CSS for rendering the user interface.
  
- **Server**: Implements the backend logic using Gleam. It handles routing, database interactions, and web server functionalities.

- **Shared**: Acts as a shared library between the client and server components. It contains common data models, APIs, and utility functions that are used across both ends of the application.

The Dockerfile orchestrates the build process by first compiling the frontend assets using Gleam's JavaScript compiler (`lustre/dev`) and then building an Erlang release for the backend. The final stage creates a minimal production runtime based on Alpine Linux, ensuring efficient deployment.

## Tech Stack:

- **Programming Language**: [Gleam](https://gleam.run/)
- **Frontend Framework**: Built using Gleam's JavaScript compiler (`lustre/dev`) for compiling to JavaScript.
- **Backend Framework**: Erlang-based backend with routing and web server functionalities.
- **Containerization**: Docker
- **Build Tool**: Gleam package manager (`gleam deps download`)

## Getting Started / Setup Guide:

### Prerequisites:
1. Install [Docker](https://docs.docker.com/get-docker/) on your machine.
2. Ensure you have access to the `ghcr.io/gleam-lang/gleam:v1.14.0-erlang-alpine` Docker image.

### Steps to Run the Application:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo-url/gleamfullstack.git
   cd gleamfullstack
   ```

2. **Build and Run the Docker Container**:
   ```bash
   docker-compose up --build
   ```
   This command will build the Docker image using the provided `Dockerfile` and start the application.

3. **Access the Application**:
   Once the containers are running, you can access the application by navigating to `http://localhost:8080` in your web browser.

### Additional Commands:

- **Stop the Containers**:
  ```bash
  docker-compose down
  ```

- **View Logs**:
  ```bash
  docker-compose logs
  ```

This setup ensures that both the frontend and backend are built and deployed together, leveraging Docker for a consistent and isolated environment.