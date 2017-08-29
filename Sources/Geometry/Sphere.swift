import VectorMath
import RaytracerLib
import Foundation

public struct Sphere: ContainedSurface {
  let center: Vector4
  let radius: Scalar
  let material: Material

  public init(center: Vector4, radius: Scalar, material: Material) {
    self.center = center
    self.radius = radius
    self.material = material
  }
  
  public func boundingBox() -> BoundingBox {
    return BoundingBox(
      minCorner: center - Vector(x: radius, y: radius, z: radius),
      maxCorner: center + Vector(x: radius, y: radius, z: radius)
    )
  }
  
  public func containsPoint(_ point: Vector4) -> Bool {
    return (point - center).lengthSquared < radius*radius
  }
  
  public func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
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
      let t2 = (-b + sqrt(descriminant)) / (2*a)
      
      if t >= min && t <= max {
        let point = ray.pointAt(t)
        return Intersection(
          point: point,
          normal: normalAt(point),
          material: material,
          ray: ray,
          time: ray.time
        )
      } else if t2 >= min && t <= max {
        let point = ray.pointAt(t2)
        return Intersection(
          point: point,
          normal: normalAt(point),
          material: material,
          ray: ray,
          time: ray.time
        )
      } else {
        return nil
      }
    }
  }
  
  public func normalAt(_ point: Vector4) -> Vector4 {
    return (point - center).normalized()
  }
}
