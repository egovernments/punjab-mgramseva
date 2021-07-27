FROM debian:latest  AS build
ARG WORK_DIR
WORKDIR /app


# copy the project files
COPY ${WORK_DIR} .
RUN flutter  build --web-renderer

# Create runtime image
FROM nginx:mainline-alpine
ENV WEB_DIR=/var/web/

RUN mkdir -p ${WEB_DIR}

COPY --from=build /app/packages/employee/build ${WEB_DIR}/