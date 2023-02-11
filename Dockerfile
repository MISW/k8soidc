# workspace
FROM golang:1.20 AS workspace

COPY . /k8soidc

WORKDIR /k8soidc

RUN go mod download \
 && go build -buildmode pie -o /k8soidc/k8soidc

# production
FROM gcr.io/distroless/base:debug AS production

RUN ["/busybox/sh", "-c", "ln -s /busybox/sh /bin/sh"]
RUN ["/busybox/sh", "-c", "ln -s /bin/env /usr/bin/env"]

COPY --from=workspace /k8soidc/k8soidc /bin/k8soidc

ENTRYPOINT ["/bin/k8soidc"]
