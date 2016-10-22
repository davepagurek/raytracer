import Foundation

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
