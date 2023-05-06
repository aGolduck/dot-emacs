import * as log from "https://deno.land/std/log/mod.ts";
import { parse } from "https://deno.land/std/flags/mod.ts";
const flags = parse(Deno.args, {
  string: ["std-log-level"]
})
const STD_LOG_LEVEL = flags["std-log-level"] as "DEBUG" | "INFO" | "ERROR" | "NOTSET" | "WARNING" | "CRITICAL" || "INFO"
await log.setup({
  handlers: {
    console: new log.handlers.ConsoleHandler(STD_LOG_LEVEL),
  },
  loggers: {
    default: {
      level: STD_LOG_LEVEL,
      handlers: ["console"],
    },
  },
});

log.debug("init")
