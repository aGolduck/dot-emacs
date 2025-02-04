import * as log from "jsr:@std/log";
import { parse } from "jsr:@std/flags";
const flags = parse(Deno.args, {
  string: ["std-log-level"]
})
const STD_LOG_LEVEL = flags["std-log-level"] as "DEBUG" | "INFO" | "ERROR" | "NOTSET" | "WARNING" | "CRITICAL" || "INFO"
await log.setup({
  handlers: {
    console: new log.ConsoleHandler(STD_LOG_LEVEL),
  },
  loggers: {
    default: {
      level: STD_LOG_LEVEL,
      handlers: ["console"],
    },
  },
});

log.debug("init")
