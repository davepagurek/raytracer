import Foundation

struct Skin {
  let material: Material
  let probability: Scalar
}

struct Volume: ContainedSurface {
  let surface: ContainedSurface
  let density: Scalar
  let skin: Skin?
  
  func boundingBox() -> BoundingBox {
    return surface.boundingBox()
  }
  
  func containsPoint(_ point: Vector4) -> Bool {
    return surface.containsPoint(point)
  }
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    let start, end: Intersection?
    if containsPoint(ray.point) {
      end = surface.intersectsRay(ray, min: min, max: max)
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
      start = surface.intersectsRay(ray, min: min, max: max)
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
            point: start.point + ray.direction.normalized() * min,
            direction: ray.direction,
            color: ray.color,
            time: ray.time
          )
          end = surface.intersectsRay(nextRay, min: min, max: max)
        }
      } else {
        end = nil
      }
    }
    if let start = start, let end = end {
      let path = end.point - start.point
      let probabilityHitAnything = path.length * density
      if rand(0, 1) < probabilityHitAnything {
        let randomProbability = rand(0, probabilityHitAnything)
        let bounceDistance = randomProbability / density
        return Intersection(
          point: start.point + path.normalized()*bounceDistance,
          normal: ray.direction.normalized() * -1,
          material: start.material,
          time: start.time
        )
      }
    }
    
    return nil
  }
}
