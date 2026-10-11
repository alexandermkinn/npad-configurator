FROM nginx:1.27-alpine

# Ship sets PORT for the primary endpoint; default for local runs.
ENV PORT=8080

# nginx renders /etc/nginx/templates/*.template with env vars at startup.
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY index.html og.png /usr/share/nginx/html/

EXPOSE 8080
