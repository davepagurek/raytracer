import Foundation

struct Camera {
  let origin, swCorner, h, v: Vector4
  let aperture, focalDistance: Scalar
  
  init(from: Vector4, to: Vector4, up: Vector4, vfov: Scalar, aspect: Scalar, aperture: Scalar, focalDistance: Scalar) {
    let theta = Double(vfov) * M_PI/180
    let halfHeight:Scalar = Scalar(tan(theta/2))
    let halfWidth:Scalar = aspect*halfHeight
    
    let direction = (from - to).normalized()
    let x3 = up.xyz.cross(direction.xyz).normalized()
    let y3 = direction.xyz.cross(x3).normalized()
    let x = Vector(x: x3.x, y: x3.y, z: x3.z)
    let y = Vector(x: y3.x, y: y3.y, z: y3.z)
    
    swCorner = from - (x*halfWidth*focalDistance) - (y*halfHeight*focalDistance) - (direction*focalDistance)
    h = x * halfWidth * focalDistance * 2
    v = y * halfHeight * focalDistance * 2
    origin = from
    
    self.aperture = aperture
    self.focalDistance = focalDistance
  }
  
  func rayAt(x: Scalar, y: Scalar, time: TimeRange) -> Ray {
    let randomInLens = randomVectorInDisc()*aperture*0.5
    let offset = h*randomInLens.x + v*randomInLens.y
    return Ray(
      point: origin + offset,
      direction: (swCorner + (h*x) + (v*(1-y))) - origin - offset,
      color: Color(0xFFFFFF),
      time: time
    )
  }
}
