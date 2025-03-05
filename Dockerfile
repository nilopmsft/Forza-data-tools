# syntax=docker/dockerfile:1

FROM golang:1.22 AS build

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /app/fdt

# Optional:
# To bind to a TCP port, runtime parameters must be supplied to the docker command.
# But we can document in the Dockerfile what ports
# the application is going to listen on by default.
# https://docs.docker.com/reference/dockerfile/#expose
FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /app

COPY --from=build /app/fdt /app/fdt
COPY *.dat ./

EXPOSE 8080
EXPOSE 9999

USER nonroot:nonroot

# Run
CMD ["/app/fdt", "-j",  "-e"]