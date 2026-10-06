import os
from flask import Flask
from database.db import initialize_db
from flask_restful import Api
from resources.errors import errors
from dotenv import load_dotenv

app = Flask(__name__)

app.config["DEBUG"] = True
app.config.from_envvar('ENV_FILE_LOCATION')

load_dotenv()

# DB_NAME = os.getenv('DB_NAME')
# DATABASE_USERNAME = os.getenv('DATABASE_USERNAME')
# DATABASE_PASSWORD = os.getenv('DATABASE_PASSWORD')
# MONGODB_HOST = os.getenv('MONGODB_HOST')
# MONGODB_PORT = os.getenv('MONGODB_PORT')

app.config['MONGODB_SETTINGS'] = {
    'host': os.getenv('MONGO_URL')
}


initialize_db(app)

api = Api(app, errors=errors)

from resources.routes import initialize_routes
initialize_routes(api)



