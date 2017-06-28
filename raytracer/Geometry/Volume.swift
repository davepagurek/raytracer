import Foundation

struct Skin {
  let material: Material
  let probability: Scalar
}

struct Volume: ContainedSurface {
  let object: ContainedSurface
  let density: Scalar
  let skin: Skin?
  
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
    let start, end: Intersection?
    if containsPoint(ray.point) {
      end = object.intersectsRay(ray, min: minimum, max: maximum)
      if let end = end {
        start = Intersection(
          point: ray.point,
          normal: randomVector(),
          material: end.material,
          time: ray.time
        )
      } else {
        return nil // intersection right on edge, perpendicular to normal
      }
    } else {
      start = object.intersectsRay(ray, min: minimum, max: maximum)
      if let start = start {
        if let skin = skin, rand(0, 1) <= skin.probability {
          return Intersection(
            point: start.point,
            normal: start.normal,
            material: skin.material,
            time: start.time
          )
        } else {
          let nextRay = Ray(
            point: start.point + ray.direction.normalized() * minimum,
            direction: ray.direction,
            color: ray.color,
            time: ray.time
          )
          end = object.intersectsRay(nextRay, min: minimum, max: maximum)
        }
      } else {
        end = nil
      }
    }
    if let start = start, let end = end {
      let path = end.point - start.point
      let distanceTravelled = -log(rand(0,1))/density
      if distanceTravelled < path.length {
        return Intersection(
          point: start.point + path.normalized()*distanceTravelled,
          normal: ray.direction.normalized() * -1,
          material: start.material,
          time: start.time
        )
      }
    }
    
    return nil
  }
}
