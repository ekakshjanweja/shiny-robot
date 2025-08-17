import { defineConfig } from "drizzle-kit";
import { loadConfig } from "./src/lib/config";

export default defineConfig({
  dialect: "postgresql",
  schema: "./src/lib/db/schema/auth.ts",
  out: "./src/lib/db/generated",
  dbCredentials: {
    url: loadConfig().DATABASE_URL,
  },
  verbose: true,
  strict: true,
});
