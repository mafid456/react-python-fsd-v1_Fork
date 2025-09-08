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
# 2) Backend
# ============================
FROM node:18-alpine AS backend

WORKDIR /app

# Copy backend dependencies
COPY backend/package*.json ./
RUN npm install

# If your backend also uses Python (requirements.txt)
# Uncomment these lines:
# RUN apk add --no-cache python3 py3-pip
# COPY backend/requirements.txt .
# RUN pip3 install -r requirements.txt

# Copy backend source
COPY backend/ .

# Copy built frontend into backend's public folder
COPY --from=frontend-build /frontend/dist ./public

# Expose backend port
EXPOSE 3000

# Start backend
CMD ["npm", "start"]
