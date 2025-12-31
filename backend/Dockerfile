# Build stage
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Runtime stage
FROM python:3.11-slim

WORKDIR /app

RUN useradd -m appuser

COPY --from=builder /usr/local /usr/local
COPY . .

USER appuser

EXPOSE 5000
CMD ["python", "app.py"]
