FROM nginx:1.27-alpine

RUN apk add --no-cache supervisor wget

# Copy your built frontend files here.
# Adjust this if your frontend build output is named dist or build.
COPY public/ /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

# Download the exporter during the remote GitHub Actions build.
ARG NGINX_EXPORTER_VERSION=1.4.0
RUN wget -q -O /tmp/nginx-exporter.tar.gz \
    https://github.com/nginx/nginx-prometheus-exporter/releases/download/v${NGINX_EXPORTER_VERSION}/nginx-prometheus-exporter_${NGINX_EXPORTER_VERSION}_linux_amd64.tar.gz \
    && tar -xzf /tmp/nginx-exporter.tar.gz -C /tmp \
    && mv /tmp/nginx-prometheus-exporter /usr/local/bin/nginx-prometheus-exporter \
    && chmod +x /usr/local/bin/nginx-prometheus-exporter \
    && rm -rf /tmp/nginx-exporter.tar.gz

EXPOSE 80 9113

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]