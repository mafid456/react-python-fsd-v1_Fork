# ============================
# 1) Build Frontend (Vite + React)
# ============================
FROM node:18-alpine AS frontend-build

WORKDIR /frontend

# Copy frontend dependencies
COPY frontend/package*.json ./
RUN npm install

# Copy frontend source
COPY frontend/ .

# Build frontend
RUN npm run build


# ============================
# 2) Backend (Python + FastAPI/Flask)
# ============================
FROM python:3.11-slim AS backend

WORKDIR /app

# Install dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source code
COPY backend/ .

# Copy built frontend into backend static folder
COPY --from=frontend-build /frontend/dist ./app/static

# Expose backend port
EXPOSE 3000

# Start backend (FastAPI with uvicorn)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "3000"]
