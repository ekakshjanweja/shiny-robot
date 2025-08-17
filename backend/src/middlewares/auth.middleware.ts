import { MiddlewareHandler } from "hono";
import { AppBindings } from "../lib/types";
import { loadConfig } from "../lib/config";
import { createDb } from "../lib/db";
import { createAuth } from "../lib/auth";

const authMiddleware: MiddlewareHandler<AppBindings> = async (c, next) => {
  const env = loadConfig();

  c.set("env", env);

  const db = createDb(env.DATABASE_URL);
  const auth = createAuth({ db, env });

  c.set("db", db);
  c.set("auth", auth);

  const session = await auth.api.getSession({ headers: c.req.raw.headers });

  if (!session) {
    c.set("user", null);
    c.set("session", null);
    return next();
  }

  c.set("user", session.user);
  c.set("session", session.session);
  return next();
};

export default authMiddleware;
