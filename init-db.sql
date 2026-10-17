-- Initialize Immo3D PostgreSQL Database
-- PostgreSQL 16 with pgvector extension

-- Create pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create basic schema for Immo3D
CREATE SCHEMA IF NOT EXISTS immo3d;
SET search_path TO immo3d, public;

-- Properties table (Immobilien)
CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  uuid UUID DEFAULT gen_random_uuid() UNIQUE NOT NULL,
  address VARCHAR(255) NOT NULL,
  city VARCHAR(100) NOT NULL,
  postal_code VARCHAR(10) NOT NULL,
  country VARCHAR(100) DEFAULT 'DE',
  property_type VARCHAR(50) NOT NULL, -- apartment, house, office, commercial
  area_sqm DECIMAL(10, 2) NOT NULL,
  rooms INT,
  bathrooms INT,
  price DECIMAL(15, 2),
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by UUID,
  embedding vector(1536) -- OpenAI embedding dimension
);

CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_type ON properties(property_type);
CREATE INDEX idx_properties_embedding ON properties USING ivfflat (embedding vector_cosine_ops);

-- Agents table (KI-Agenten)
CREATE TABLE agents (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  role VARCHAR(100) NOT NULL,
  status VARCHAR(20) DEFAULT 'active', -- active, inactive, maintenance
  last_heartbeat TIMESTAMP,
  config JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tasks/Jobs for LangGraph
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  uuid UUID DEFAULT gen_random_uuid() UNIQUE NOT NULL,
  property_id INT REFERENCES properties(id),
  agent_id INT REFERENCES agents(id),
  task_type VARCHAR(100) NOT NULL, -- valuation, inspection, negotiation, etc.
  status VARCHAR(50) DEFAULT 'pending', -- pending, running, completed, failed
  input_data JSONB,
  output_data JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  started_at TIMESTAMP,
  completed_at TIMESTAMP
);

CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_property ON tasks(property_id);

-- Audit log
CREATE TABLE audit_log (
  id SERIAL PRIMARY KEY,
  entity_type VARCHAR(100),
  entity_id INT,
  action VARCHAR(50),
  changes JSONB,
  user_id UUID,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

GRANT ALL PRIVILEGES ON SCHEMA immo3d TO immo3d_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA immo3d TO immo3d_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA immo3d TO immo3d_user;
