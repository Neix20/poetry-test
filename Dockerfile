FROM python:3-alpine3.20

# Create a non-root user
RUN addgroup -S appgroup && adduser -S -G appgroup -u 1000 appuser

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Set cache directory for Poetry
ENV POETRY_CACHE_DIR="/tmp/poetry-cache"
ENV PATH="/opt/venv/bin:$PATH"

# Install Poetry and dependencies in a virtual environment
RUN pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-root && \
    mkdir -p $POETRY_CACHE_DIR && \
    chown -R appuser:appgroup $POETRY_CACHE_DIR

# Switch to non-root user
USER appuser

EXPOSE 8080

# Run FastAPI using Uvicorn
CMD ["fastapi", "run", "app/main.py", "--port", "8080", "--host", "0.0.0.0"]
