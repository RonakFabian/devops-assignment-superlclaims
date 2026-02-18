from celery import Celery
import time
import os

# Environment variables
REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379/0")
LOG_FILE = os.getenv("LOG_FILE", "log_celery.txt")
TASK_DELAY = int(os.getenv("TASK_DELAY", "10"))
CELERY_APP_NAME = os.getenv("CELERY_APP_NAME", "worker")

# Configure Celery
celery = Celery(
    CELERY_APP_NAME,
    broker=REDIS_URL,
    backend=REDIS_URL,
)

@celery.task
def write_log_celery(message: str):
    time.sleep(TASK_DELAY)
    with open(LOG_FILE, "a") as f:
        f.write(f"{message}\n")
    return f"Task completed: {message}"
