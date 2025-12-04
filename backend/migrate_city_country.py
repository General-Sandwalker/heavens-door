from app.database import engine
from sqlalchemy import text

conn = engine.connect()
try:
    conn.execute(text("ALTER TABLE properties ADD COLUMN city VARCHAR(100) NOT NULL DEFAULT ''"))
    conn.execute(text("ALTER TABLE properties ADD COLUMN country VARCHAR(100) NOT NULL DEFAULT ''"))
    conn.commit()
    print('Migration successful: Added city and country columns')
except Exception as e:
    print(f'Error: {e}')
    conn.rollback()
finally:
    conn.close()
