# this file defines the database connection and session management

import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
# from dotenv import load_dotenv
from models import Base
from sqlalchemy_utils import database_exists, create_database

#! if use environment in docker compose then no need to load from dotenv
# # Option 1: Load environment variables from the .env file
# load_dotenv()

# Access environment variables
# MYSQL_HOST = os.environ.get("MYSQL_HOST")
# MYSQL_USER = os.environ.get("MYSQL_USER")
# # MYSQL_PORT = int(os.environ.get("MYSQL_PORT"))
# MYSQL_PASSWORD = os.environ.get("MYSQL_PASSWORD")
# MYSQL_DB = os.environ.get("MYSQL_DB")

# Option 2: Define your database configuration directly
MYSQL_HOST = "mysql_db"
MYSQL_USER = "bong"
MYSQL_PASSWORD = "bong"
MYSQL_DB = "audit"

MYSQL_DB_URL = f"mysql+mysqlconnector://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}/{MYSQL_DB}"

engine = create_engine(
    MYSQL_DB_URL,
)

# auto create database if not exists
if not database_exists(engine.url):
    create_database(engine.url)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# create tables if they do not exist in the db
Base.metadata.create_all(bind=engine)

# dependency to get the database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

