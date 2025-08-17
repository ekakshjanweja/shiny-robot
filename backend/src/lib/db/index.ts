import { drizzle } from "drizzle-orm/node-postgres";
import { account, session, user, verification } from "./schema/auth";

export function createDb(connectionString: string) {
  const db = drizzle(connectionString, {
    schema: {
      user,
      session,
      account,
      verification,
    },
  });

  return db;
}

export type DbType = ReturnType<typeof createDb>;
