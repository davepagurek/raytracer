import Foundation

struct Camera {
  let origin, swCorner, h, v: Vector4
  
  init(origin: Vector4, vfov: Scalar, aspect: Scalar) {
    let theta = Double(vfov) * M_PI/180
    let halfHeight:Scalar = 1 //Scalar(tan(theta/2))
    let halfWidth:Scalar = 2 // aspect*halfHeight
    
    swCorner = origin + Vector(x: -halfWidth, y: -halfHeight, z: -3)
    h = Vector(x: 2*halfWidth, y: 0, z: 0)
    v = Vector(x: 0, y: 2*halfHeight, z: 0)
    self.origin = origin
  }
  
  func rayAt(x: Scalar, y: Scalar) -> Ray {
    let origin = Point(x: 0, y: 0, z: 0)
    return Ray(
      point: origin,
      direction: (swCorner + (h*x) + (v*(1-y))) - origin,
      color: Color(0xFFFFFF)
    )
  }
}
