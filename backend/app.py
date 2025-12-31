from flask import Flask
import psycopg2
import os

app = Flask(__name__)

# Environment variables
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

def get_db_connection():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

@app.route("/")
def home():
    return "Backend Running Successfully!"

@app.route("/health")
def health():
    try:
        conn = get_db_connection()
        conn.close()
        return {
            "status": "OK",
            "database": "connected"
        }
    except Exception as e:
        return {
            "status": "DOWN",
            "database": "not connected",
            "error": str(e)
        }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
