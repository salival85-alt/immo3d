# Immo3D Deployment Guide

## Lokal starten (Development)

### Voraussetzungen
- Docker + Docker Compose
- Python 3.12
- Git

### 1. Repository klonen
```bash
git clone https://github.com/salival85-alt/immo3d.git
cd immo3d
```

### 2. Environment konfigurieren
```bash
cp .env.example .env
# Ggf. Secrets anpassen
```

### 3. Docker Stack starten
```bash
docker-compose up -d
```

### 4. Services prüfen
```bash
docker-compose ps
```

**Services:**
- **PostgreSQL**: `localhost:5432` (immo3d_user / immo3d_password)
- **pgAdmin**: http://localhost:5050 (admin@immo3d.local / admin)
- **Redis**: `localhost:6379`
- **Redis Commander**: http://localhost:8081

### 5. Python Environment + API starten
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
cd backend
uvicorn main:app --reload
```

API läuft auf http://localhost:8000

**OpenAPI Docs:**
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Database Migrations (Alembic)

```bash
# Neue Migration erstellen
alembic revision --autogenerate -m "description"

# Upgrade auf neueste Version
alembic upgrade head

# Downgrade um eine Version
alembic downgrade -1
```

## Docker Cleanup

```bash
# Alle Container stoppen
docker-compose down

# Volumes löschen (ACHTUNG: löscht Daten!)
docker-compose down -v
```

## Struktur

```
immo3d/
├── backend/
│   ├── api/          # FastAPI Routes (TODO)
│   ├── agents/       # 7 KI-Agenten (TODO)
│   ├── db/           # ORM Models + Migrations
│   ├── core/         # Auth, Config, Utils
│   └── main.py       # Entry Point
├── infra/
│   ├── docker-compose.yml
│   └── prometheus/   # TODO
├── tests/
├── .github/
│   └── workflows/    # CI/CD Pipelines
└── docs/             # TODO
```

## CI/CD Pipeline

Automatisch getriggert bei:
- Push zu `master`, `main`, `develop`
- Pull Requests

Pipeline führt aus:
1. **Lint** (pylint, black, mypy)
2. **Tests** (pytest mit Coverage)
3. **Docker Build** (nur master)

---

*Letzte Aktualisierung: 17.10.2026*
