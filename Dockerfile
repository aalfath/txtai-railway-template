# txtai API for Railway: official CPU image, pinned by version and digest.
# Upstream: https://github.com/neuml/txtai  Image: https://hub.docker.com/r/neuml/txtai-cpu
FROM neuml/txtai-cpu:9.14.0@sha256:199b05d8bd4edd9cd63c6579ba929787dd9bc8421db9ad11a4584714c271eba9

# Hugging Face model cache and the index live on the Railway volume at /data
ENV HF_HOME=/data/hf \
    HF_HUB_DISABLE_TELEMETRY=1 \
    PYTHONUNBUFFERED=1

COPY start.py /railway/start.py

EXPOSE 8000
ENTRYPOINT ["python", "/railway/start.py"]
