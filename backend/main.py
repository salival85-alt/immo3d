"""Immo3D API - Main FastAPI Application"""
import os
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Import routers (will be created)
# from backend.api.routes import properties, agents, tasks

# Database imports
# from backend.db.database import engine, Base

# Startup/Shutdown
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Manage app lifecycle"""
    # Startup
    print("🚀 Immo3D API starting...")
    yield
    # Shutdown
    print("🛑 Immo3D API shutting down...")


# Create FastAPI app
app = FastAPI(
    title="Immo3D API",
    description="KI-Agenten für Immobilienverwaltung",
    version="0.1.0",
    lifespan=lifespan,
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=os.getenv("CORS_ORIGINS", "*").split(","),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Health check endpoint
@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "ok",
        "service": "immo3d-api",
        "version": "0.1.0",
    }


# Root endpoint
@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "name": "Immo3D API",
        "description": "KI-Agenten für Immobilienverwaltung",
        "docs": "/docs",
        "redoc": "/redoc",
    }


# TODO: Include routers
# app.include_router(properties.router, prefix="/api/v1/properties", tags=["properties"])
# app.include_router(agents.router, prefix="/api/v1/agents", tags=["agents"])
# app.include_router(tasks.router, prefix="/api/v1/tasks", tags=["tasks"])


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=os.getenv("API_HOST", "0.0.0.0"),
        port=int(os.getenv("API_PORT", 8000)),
        reload=os.getenv("DEBUG", "True").lower() == "true",
    )
