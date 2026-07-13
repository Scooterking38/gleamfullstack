import gleam/erlang/os
import gleam/erlang/process
import gleam/int
import gleam/io
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  // 1. Wisp requires a secret key for signing cookies/sessions
  let secret_key_base = wisp.random_string(64)

  // 2. Read the port assigned by SnapDeploy (defaults to 8080 if not set)
  let port =
    os.get_env("PORT")
    |> wisp.string_value
    |> int.parse
    |> wisp.unwrap_or(8080)

  // 3. Start the server
  let assert Ok(_) =
    handle_request
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(port)
    |> mist.bind("0.0.0.0") // Crucial for Docker routing
    |> mist.start_http

  io.print_line("🚀 Server is running on http://localhost:" <> int.to_string(port))
  process.sleep_forever()
}

fn handle_request(req: wisp.Request) -> wisp.Response {
  // 4. Automatically serve compiled Lustre assets from Stage 2 of Dockerfile
  use req <- wisp.serve_static(req, under: "/", from: "priv/static")

  // Fallback API or HTML routing
  case wisp.path_segments(req) {
    [] -> wisp.html_response(
      "<!DOCTYPE html><html><head><script type='module' src='/client.js'></script></head><body><div id='app'></div></body></html>",
      200
    )
    ["api", "health"] -> wisp.json_response("{\"status\": \"ok\"}", 200)
    _ -> wisp.not_found()
  }
}
