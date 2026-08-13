import requests

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError


# ============================================================
# Cognito Configuration
# ============================================================

COGNITO_REGION = "us-east-1"

COGNITO_USER_POOL_ID = "us-east-1_1jyc5TNuA"

COGNITO_APP_CLIENT_ID = "10ncquo7nn7941oj3poqqj7khc"

ISSUER = (
    f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/"
    f"{COGNITO_USER_POOL_ID}"
)

JWKS_URL = f"{ISSUER}/.well-known/jwks.json"


security = HTTPBearer()


# ============================================================
# Get Cognito Public Keys
# ============================================================

jwks = requests.get(JWKS_URL).json()


# ============================================================
# Validate JWT
# ============================================================

def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):

    token = credentials.credentials

    try:

        header = jwt.get_unverified_header(token)

        key = next(
            key
            for key in jwks["keys"]
            if key["kid"] == header["kid"]
        )

        payload = jwt.decode(
            token,
            key,
            algorithms=["RS256"],
            audience=COGNITO_APP_CLIENT_ID,
            issuer=ISSUER,
        )

        return payload

    except (JWTError, StopIteration):

        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired authentication token",
            headers={"WWW-Authenticate": "Bearer"},
        )