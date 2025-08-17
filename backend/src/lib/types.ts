import { Session, User } from "better-auth";
import { DbType } from "./db";
import { AuthType } from "./auth";
import { EnvBindings } from "./config";

export type AppBindings = {
  Variables: {
    env: EnvBindings;
    user: User | null;
    session: Session | null;
    db: DbType;
    auth: AuthType;
  };
};
