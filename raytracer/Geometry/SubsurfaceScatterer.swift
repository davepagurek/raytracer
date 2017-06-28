import Foundation

struct SubsurfaceMaterial {
  let density: Scalar
  let color: Color
  let bounceFn: (Vector4, Vector4) -> Vector4
}

struct SubsurfaceScatterer : ContainedSurface {
  let object: ContainedSurface
  let density: Scalar
  let color: Color
  
  func boundingBox() -> BoundingBox {
    return object.boundingBox()
  }
  
  func containsPoint(_ point: Vector4) -> Bool {
    return object.containsPoint(point)
  }
  
  func normalAt(_ point: Vector4) -> Vector4 {
    return object.normalAt(point)
  }
  
  func intersectsRay(_ ray: Ray, min minimum: Scalar, max maximum: Scalar) -> Intersection? {
    if let start = object.intersectsRay(ray, min: minimum, max: maximum) {
      var nextRay: Ray = Ray(
        point: start.point + ray.direction.normalized() * minimum,
        direction: ray.direction,
        color: ray.color,
        time: ray.time
      )
      var prevIntersection: Intersection = start
      
      while true {
        if let end = object.intersectsRay(nextRay, min: minimum, max: maximum) {
          let path = end.point - nextRay.point
          let distanceTravelled = -log(rand(0,1)*density)
          if distanceTravelled < path.length {
            let nextPoint = nextRay.point + path.normalized()*distanceTravelled
            nextRay = Ray(
              point: nextPoint,
              direction: randomVector(),
              color: nextRay.color.multiply(color),
              time: nextRay.time
            )
            prevIntersection = end
          } else {
            return end
          }
        } else {
          // Basically on the edge
          return prevIntersection
        }
      }
    } else {
      return nil
    }
  }
}
