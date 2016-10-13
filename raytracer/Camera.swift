import Foundation

struct Camera {
  let origin, swCorner, h, v: Vector4
  
  init(from: Vector4, to: Vector4, up: Vector4, vfov: Scalar, aspect: Scalar) {
    let theta = Double(vfov) * M_PI/180
    let halfHeight:Scalar = Scalar(tan(theta/2))
    let halfWidth:Scalar = aspect*halfHeight
    
    let direction = (from - to).normalized()
    let x3 = up.xyz.cross(direction.xyz).normalized()
    let y3 = direction.xyz.cross(x3).normalized()
    let x = Vector(x: x3.x, y: x3.y, z: x3.z)
    let y = Vector(x: y3.x, y: y3.y, z: y3.z)
    
    swCorner = from - (x*halfWidth) - (y*halfHeight) - direction
    print(swCorner)
    h = x * halfWidth * 2
    v = y * halfHeight * 2
    origin = from
  }
  
  func rayAt(x: Scalar, y: Scalar) -> Ray {
    return Ray(
      point: origin,
      direction: (swCorner + (h*x) + (v*(1-y))) - origin,
      color: Color(0xFFFFFF)
    )
  }
}
