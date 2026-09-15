FROM eclipse-temurin:17-jre-alpine

RUN apk add --no-cache supervisor wget tar

ARG PROMETHEUS_VERSION=3.5.0
ARG CLOUDWATCH_EXPORTER_VERSION=0.16.7

RUN wget -q -O /tmp/prometheus.tar.gz \
    https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
    && tar -xzf /tmp/prometheus.tar.gz -C /tmp \
    && mv /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/prometheus \
    && mv /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/promtool \
    && mkdir -p /etc/prometheus /prometheus \
    && rm -rf /tmp/prometheus*

RUN wget -q -O /usr/local/bin/cloudwatch_exporter.jar \
    https://github.com/prometheus/cloudwatch_exporter/releases/download/v${CLOUDWATCH_EXPORTER_VERSION}/cloudwatch_exporter-${CLOUDWATCH_EXPORTER_VERSION}.jar

RUN printf '#!/bin/sh\nexec java -jar /usr/local/bin/cloudwatch_exporter.jar "$@"\n' \
    > /usr/local/bin/cloudwatch_exporter \
    && chmod +x /usr/local/bin/cloudwatch_exporter

COPY prometheus.yml /etc/prometheus/prometheus.yml
COPY cloudwatch-exporter.yml /etc/cloudwatch-exporter/config.yml
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 9090 9106

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]