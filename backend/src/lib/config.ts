import * as dotenv from "dotenv";

export function getEnv(): NodeJS.ProcessEnv {
  dotenv.config();
  return process.env;
}

export function loadConfig() {
  const source = getEnv();

  const DATABASE_URL = source.DATABASE_URL;
  const BETTER_AUTH_SECRET = source.BETTER_AUTH_SECRET;
  const BETTER_AUTH_URL = source.BETTER_AUTH_URL;
  const GOOGLE_GENERATIVE_AI_API_KEY = source.GOOGLE_GENERATIVE_AI_API_KEY;

  if (
    !DATABASE_URL ||
    !BETTER_AUTH_SECRET ||
    !BETTER_AUTH_URL ||
    !GOOGLE_GENERATIVE_AI_API_KEY
  ) {
    throw new Error("Missing required environment variables.");
  }

  return {
    DATABASE_URL,
    BETTER_AUTH_SECRET,
    BETTER_AUTH_URL,
    GOOGLE_GENERATIVE_AI_API_KEY,
  } as const;
}

export type EnvBindings = ReturnType<typeof loadConfig>;
