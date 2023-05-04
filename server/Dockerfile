# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from golang:1.12-alpine base image
FROM golang:1.18-alpine

# The latest alpine images don't have some tools like (`git` and `bash`).
# Adding git, bash and openssh to the image
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependancies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

RUN go mod tidy

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

ENV API_HOST='0.0.0.0'
    
ENV API_PORT='8083'
    
ENV DB_URI='mongodb://ecoap_db:27017'
    
ENV DB_NAME='eco_un'

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /docker-gs-ping

# Expose port 8084 to the outside world
EXPOSE 8083
CMD ["/docker-gs-ping"]