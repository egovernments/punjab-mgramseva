
FROM egovio/flutter-builder:v1 AS build
ARG WORK_DIR
WORKDIR /app
# copy the project files
COPY ${WORK_DIR} .
RUN flutter upgrade
RUN flutter pub get
RUN flutter build web
# Create runtime image
FROM nginx:mainline-alpine
ENV WEB_DIR=/var/web/mgramseva
#RUN mkdir -p ${WEB_DIR}
COPY --from=build /app/build/web/ ${WEB_DIR}/
COPY --from=build /app/docker/nginx.conf /etc/nginx/conf.d/default.conf

