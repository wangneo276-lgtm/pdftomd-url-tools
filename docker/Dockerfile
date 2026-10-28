FROM busybox:1.36.1
LABEL org.opencontainers.image.title="pdftomd-url-tools" \
      org.opencontainers.image.description="Free in-browser pdf to md tool. Drop a text PDF, preview Markdown, copy or download—files stay on your device. No account required." \
      org.opencontainers.image.url="https://pdftomd.tools/" \
      org.opencontainers.image.source="https://github.com/wangneo276-lgtm/pdftomd-url-tools" \
      org.opencontainers.image.version="0.1.0" \
      org.opencontainers.image.licenses="MIT"
COPY bin/pdftomd-url-tools /usr/local/bin/pdftomd-url-tools
RUN chmod +x /usr/local/bin/pdftomd-url-tools
ENTRYPOINT ["/usr/local/bin/pdftomd-url-tools"]
