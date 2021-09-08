## 1st builder for backend
# Use golang image as a builder for backend
FROM golang:1.16.7-alpine3.14 AS builder

# Create and set workdir
WORKDIR /backend

# Copy `go.mod` for definitions and `go.sum` to invalidate the next layer
# in case of a change in the dependencies
COPY ./backend/go.mod ./backend/go.sum ./

# Install git to be used "go mod download"
RUN apk add --no-cache git

# Download dependencies
RUN go mod download

# Copy a source file and build an executable
COPY ./backend/main.go .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o devops_handson

# Use a Docker multi-stage build to create a lean production image
FROM alpine:3.14.1
RUN apk add --no-cache ca-certificates
COPY --from=builder /backend/devops_handson ./
COPY ./backend/static ./static
EXPOSE 8080
ENTRYPOINT ["/devops_handson"]
