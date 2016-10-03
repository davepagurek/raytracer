import Foundation

protocol Source {
  func colorFrom(_ ray: Ray) -> Color
}

struct Sky: Source {
  let top, bottom: Color
  
  func colorFrom(_ ray: Ray) -> Color {
    let t = 0.5 * (ray.direction.normalized().y + 1)
    let color = lerpColor(bottom, top, t)
    return Color(
      r: ray.color.r * color.r,
      g: ray.color.g * color.g,
      b: ray.color.b * color.b
    )
  }
}
