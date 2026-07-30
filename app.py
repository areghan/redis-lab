from fastapi import FastAPI, HTTPException, Request
import redis
import os

app = FastAPI()

# Read configuration from environment variables
REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))
REDIS_PASSWORD = os.getenv("REDIS_PASSWORD")


def get_redis_client():
    """
    Create and return a Redis client.
    """
    return redis.Redis(
        host=REDIS_HOST,
        port=REDIS_PORT,
        password=REDIS_PASSWORD,
        decode_responses=True
    )


@app.middleware("http")
async def log_requests(request: Request, call_next):
    print(f"{request.method} {request.url.path}")
    response = await call_next(request)
    return response


@app.get("/")
def root():
    return {
        "message": "FastAPI is working!"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.post("/cache")
def store_value(key: str, value: str):
    try:
        redis_client = get_redis_client()

        redis_client.set(key, value)

        return {
            "message": f"Stored '{key}' successfully"
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


@app.get("/cache")
def get_value(key: str):
    try:
        redis_client = get_redis_client()

        value = redis_client.get(key)

        if value is None:
            raise HTTPException(
                status_code=404,
                detail="Key not found"
            )

        return {
            "key": key,
            "value": value
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )