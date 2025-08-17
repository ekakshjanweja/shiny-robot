import { betterAuth } from "better-auth";
import { openAPI } from "better-auth/plugins";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { DbType } from "./db";
import { EnvBindings } from "./config";

export function createAuth({ db, env }: { db: DbType; env: EnvBindings }) {
  const auth = betterAuth({
    secret: env.BETTER_AUTH_SECRET,
    baseURL: env.BETTER_AUTH_URL,
    trustedOrigins: [env.BETTER_AUTH_URL],
    database: drizzleAdapter(db, { provider: "pg" }),
    emailAndPassword: {
      enabled: true,
    },
    plugins: [openAPI()],
  });

  return auth;
}

export type AuthType = ReturnType<typeof createAuth>;
