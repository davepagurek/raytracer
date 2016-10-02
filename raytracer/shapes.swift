import Foundation

typealias Face = [Vector4]

protocol Surface {
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection?
}

extension Surface {
  func intersectsRay(_ ray: Ray) -> Intersection? {
    return intersectsRay(ray, min: 0, max: Scalar.infinity)
  }
}

struct SurfaceList: Surface {
  let surfaces: [Surface]
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    return surfaces.reduce(nil) { (prev: Intersection?, next: Surface) -> Intersection? in
      let intersection = next.intersectsRay(ray, min: min, max: max)
      if let prev = prev, let intersection = intersection {
        if (prev.point - ray.point).lengthSquared > (intersection.point - ray.point).lengthSquared {
          return intersection
        } else {
          return prev
        }
      } else {
        return prev ?? intersection
      }
    }
  }
}

class Mesh {
  let faces: [Face]
  let transformations: [Matrix4]
  
  init(faces: [Face], transformations: [Matrix4] = []) {
    self.faces = faces
    self.transformations = transformations
  }
}

struct Sphere: Surface {
  let center: Vector4
  let radius: Scalar
  let material: Material
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    // Quadratic formula
    let toCenter = ray.point - center
    let a = ray.direction.lengthSquared
    let b = toCenter.dot(ray.direction) * 2
    let c = toCenter.lengthSquared - radius*radius
    let descriminant = b*b - 4*a*c
    if (descriminant < 0) {
      return nil
    } else {
      let t = (-b - sqrt(descriminant)) / (2*a)
      
      if t >= min && t <= max {
        let point = ray.pointAt(t)
        return Intersection(
          point: point,
          normal: normalAt(point),
          material: material
        )
      } else {
        return nil
      }
    }
  }
  
  func normalAt(_ point: Vector4) -> Vector4 {
    return (point - center).normalized()
  }
}
