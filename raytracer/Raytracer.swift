import Foundation

struct Raytracer {
  static let MAX_BOUNCES = 20
  
  let width: Scalar
  let height: Scalar
  let distance: Scalar
  let center: Vector4 = Point(x: 0, y: 0, z: 0)
  
  let surface: Surface
  let background: Material
  
  func rays(w: Int, h: Int) -> [[Ray]] {
    return (0..<h).map{ (y: Int) -> [Ray] in
      return (0..<w).map{ (x: Int) -> Ray in
        return Ray(
          point: center,
          direction: (Point(
            x: lerp(-width/2, width/2, Scalar(x)/Scalar(w)),
            y: lerp(height/2, -height/2, Scalar(y)/Scalar(h)),
            z: -distance
            ) - center),
          color: Color(0xFFFFFF)
        )
      }
    }
  }
  
  func rayColor(_ ray: Ray, bounce: Int = 0) -> Color {
    if bounce < Raytracer.MAX_BOUNCES, let intersection = surface.intersectsRay(ray) {
      return rayColor(intersection.bounce(ray), bounce: bounce+1)
    } else {
      return background.reflectedColor(ray)
    }
  }
  
  func render(w: Int, h: Int) -> [[Color]] {
    return rays(w: w*2, h: h*2)
      .mapGrid{ rayColor($0) }
      .blend()
  }
}
