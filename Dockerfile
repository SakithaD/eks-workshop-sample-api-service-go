# This is a multi-stage build. First we are going to compile and then
# create a small image for runtime.
#FROM golang:1.11.1 as builder
From bitnami/golang:1.18 as builder


RUN mkdir -p /go/src/github.com/eks-workshop-sample-api-service-go
WORKDIR /go/src/github.com/eks-workshop-sample-api-service-go
RUN useradd -u 10001 app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
RUN go env -w GO111MODULE=auto
RUN go mod init
RUN go mod tidy

FROM scratch

COPY --from=builder /go/src/github.com/eks-workshop-sample-api-service-go/main /main
COPY --from=builder /etc/passwd /etc/passwd
USER app

EXPOSE 8080
CMD ["/main"]
