import React, { createContext, useContext, useEffect, useState } from "react";
import type { User } from "firebase/auth";
import { onAuthStateChanged } from "firebase/auth";
import { doc, getDoc } from "firebase/firestore";
import { auth, db } from "../lib/firebase";

export type AuthState = "loading" | "unauthenticated" | "authenticated-but-unauthorized" | "authorized-admin";

interface AuthContextType {
  user: User | null;
  authState: AuthState;
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  authState: "loading"
});

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [authState, setAuthState] = useState<AuthState>("loading");

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      if (!firebaseUser) {
        setUser(null);
        setAuthState("unauthenticated");
        return;
      }

      setUser(firebaseUser);

      try {
        const userDoc = await getDoc(doc(db, "users", firebaseUser.uid));
        
        if (userDoc.exists() && userDoc.data()?.role === "admin") {
          setAuthState("authorized-admin");
        } else {
          setAuthState("authenticated-but-unauthorized");
        }
      } catch (error) {
        console.error("Failed to fetch user authorization role", error);
        setAuthState("authenticated-but-unauthorized");
      }
    });

    return () => unsubscribe();
  }, []);

  return (
    <AuthContext.Provider value={{ user, authState }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
