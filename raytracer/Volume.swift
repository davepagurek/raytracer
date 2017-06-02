import Foundation

struct Volume: FiniteSurface {
  let surface: FiniteSurface
  let density: Scalar
  
  func boundingBox() -> BoundingBox {
    return surface.boundingBox()
  }
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    if let start = surface.intersectsRay(ray, min: min, max: max) {
      let nextRay = Ray(
        point: start.point + ray.direction*0.001,
        direction: ray.direction,
        color: ray.color,
        time: ray.time
      )
      if let end = surface.intersectsRay(nextRay, min: min, max: max) {
        let path = end.point - start.point
        let bounceDistance = -(1/density)*log(rand(0, 1))
        if pow(bounceDistance, 2) <= path.lengthSquared {
          return Intersection(
            point: start.point + path.normalized()*bounceDistance,
            normal: randomVector(),
            material: start.material,
            time: start.time
          )
        }
      } else if rand(0, 1) <= density {
        return start
      }
    }
    
    return nil
  }
}
