import Foundation

struct Raytracer {
  let width: Scalar
  let height: Scalar
  let distance: Scalar
  let center: Vector4 = Point(x: 0, y: 0, z: 0)
  
  let surface: Surface
  
  func rays(w: Int, h: Int) -> [[Ray]] {
    return (0..<h).map{ (y: Int) -> [Ray] in
      return (0..<w).map{ (x: Int) -> Ray in
        return Ray(
          point: center,
          direction: (Point(
            x: lerp(-width/2, width/2, Scalar(x)/Scalar(w)),
            y: lerp(height/2, -height/2, Scalar(y)/Scalar(h)),
            z: -distance
          ) - center)
        )
      }
    }
  }
  
  func rayColor(_ ray: Ray) -> Color {
    if let intersection = surface.intersectsRay(ray) {
      return Color(
        r: Int(128 * (intersection.normal.x + 1)),
        g: Int(128 * (intersection.normal.y + 1)),
        b: Int(128 * (intersection.normal.z + 1))
      )
    } else {
      return ray.background()
    }
  }
  
  func render(w: Int, h: Int) -> [[Color]] {
    return rays(w: w*2, h: h*2)
      .mapGrid(rayColor)
      .blend()
  }
}
