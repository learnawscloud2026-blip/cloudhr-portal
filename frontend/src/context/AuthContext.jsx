import { createContext, useContext, useEffect, useState } from "react";
import { userPool } from "../config/cognito";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [accessToken, setAccessToken] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const currentUser = userPool.getCurrentUser();

    if (!currentUser) {
      setLoading(false);
      return;
    }

    currentUser.getSession((error, session) => {
      if (error || !session?.isValid()) {
        setUser(null);
        setAccessToken(null);
        localStorage.removeItem("cloudhr_access_token");
      } else {
        setUser(currentUser);

        const token = session.getAccessToken().getJwtToken();

        setAccessToken(token);

        localStorage.setItem(
          "cloudhr_access_token",
          token
        );
      }

      setLoading(false);
    });
  }, []);

  const login = async (username, password) => {
    try {
      const response = await fetch(
        "https://cognito-idp.us-east-1.amazonaws.com/",
        {
          method: "POST",

          headers: {
            "Content-Type": "application/x-amz-json-1.1",
            "X-Amz-Target": "AWSCognitoIdentityProviderService.InitiateAuth",
          },

          body: JSON.stringify({
            AuthFlow: "USER_PASSWORD_AUTH",

            ClientId: import.meta.env.VITE_COGNITO_CLIENT_ID,

            AuthParameters: {
              USERNAME: username,
              PASSWORD: password,
            },
          }),
        }
      );

      const data = await response.json();

      if (!response.ok) {
        throw new Error(
          data.message || data.__type || "Cognito authentication failed"
        );
      }

      if (data.ChallengeName === "NEW_PASSWORD_REQUIRED") {
        throw new Error(
          "A new password is required for this user."
        );
      }

      const token = data.AuthenticationResult?.AccessToken;

      if (!token) {
        throw new Error("Access token was not returned by Cognito.");
      }

      setAccessToken(token);

      localStorage.setItem(
        "cloudhr_access_token",
        token
      );

      setUser({
        username,
      });

      return data;
    } catch (error) {
      console.error("Login failed:", error);
      throw error;
    }
  };

  const logout = () => {
    const currentUser = userPool.getCurrentUser();

    if (currentUser) {
      currentUser.signOut();
    }

    localStorage.removeItem("cloudhr_access_token");

    setUser(null);
    setAccessToken(null);
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        accessToken,
        loading,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}