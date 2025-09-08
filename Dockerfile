# ============================
# 1) Build Frontend
# ============================
FROM node:18-alpine AS frontend-build

WORKDIR /frontend

# Copy frontend dependencies
COPY frontend/package*.json ./
RUN npm install

# Copy frontend source
COPY frontend/ .

# Build frontend (Vite → dist folder)
RUN npm run build


# ============================
# 2) Backend (Python)
# ============================
FROM python:3.11-slim AS backend

WORKDIR /app

# Install backend dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source
COPY backend/ .

# Copy built frontend into backend's static/public folder
# (Assuming your FastAPI/Flask app serves from ./app/static or ./app/public)
COPY --from=frontend-build /frontend/dist ./app/static

# Expose backend port
EXPOSE 3000

# Start backend (FastAPI with uvicorn)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "3000"]
