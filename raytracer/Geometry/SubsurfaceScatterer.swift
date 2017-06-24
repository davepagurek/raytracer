struct SubsurfaceMaterial {
  let density: Scalar
  let color: Color
  let bounceFn: (Vector4, Vector4) -> Vector4
}

struct SubsurfaceScatterer : ContainedSurface {
  let object: ContainedSurface
  let subsurface: SubsurfaceMaterial
  
  func boundingBox() -> BoundingBox {
    return object.boundingBox()
  }
  
  func containsPoint(_ point: Vector4) -> Bool {
    return object.containsPoint(point)
  }
  
  func normalAt(_ point: Vector4) -> Vector4 {
    return object.normalAt(point)
  }
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    if let start = object.intersectsRay(ray, min: min, max: max) {
      var nextRay: Ray = Ray(
        point: start.point + ray.direction.normalized() * min,
        direction: ray.direction,
        color: ray.color,
        time: ray.time
      )
      var prevIntersection: Intersection = start
      
      while true {
        if let end = object.intersectsRay(nextRay, min: min, max: max) {
          let path = end.point - nextRay.point
          let probabilityHitAnything = path.length * subsurface.density
//          if rand(0,1) > 0.9 {
//            print(probabilityHitAnything)
//          }
          if rand(0, 1) < probabilityHitAnything {
            let randomProbability = rand(0, probabilityHitAnything)
            let bounceDistance = randomProbability / subsurface.density
            let nextPoint = nextRay.point + path.normalized()*bounceDistance
            nextRay = Ray(
              point: nextPoint,
              direction: subsurface.bounceFn(
                nextRay.direction,
                object.normalAt(nextPoint)
              ),
              color: nextRay.color.multiply(subsurface.color),
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
