import lustre
import lustre/element/html

pub fn main() {
  let app = lustre.element(html.div([], [html.text("Hello from Client!")]))
  lustre.start(app, "#app", Nil)
}
