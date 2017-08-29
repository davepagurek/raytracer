import VectorMath
import Foundation

public protocol Background {
  func colorFrom(_ ray: Ray) -> Color
}

public struct Sky: Background {
  let top, bottom: Color

  public init(top: Color, bottom: Color) {
    self.top = top
    self.bottom = bottom
  }
  
  public func colorFrom(_ ray: Ray) -> Color {
    let t = 0.5 * (ray.direction.normalized().y + 1)
    let color = lerpColor(bottom, top, t)
    return Color(
      r: ray.color.r * color.r,
      g: ray.color.g * color.g,
      b: ray.color.b * color.b
    )
  }
}
