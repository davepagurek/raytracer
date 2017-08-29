import VectorMath
import RaytracerLib

public struct InfinitePlane: Surface {
  let anchor: Vector4
  let normal: Vector4
  let material: Material
  
  public init(anchor: Vector4, normal: Vector4, material: Material) {
    self.anchor = anchor
    self.normal = normal.normalized()
    self.material = material
  }
  
  public func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    if ray.direction.dot(normal) ~= 0 {
      return Intersection(
        point: ray.point,
        normal: normal,
        material: material,
        ray: ray,
        time: ray.time
      )
    } else {
      let t = (anchor - ray.point).dot(normal) / ray.direction.dot(normal)
      
      if t >= min && t <= max {
        return Intersection(
          point: ray.point + ray.direction*t,
          normal: normal * (ray.direction.dot(normal) > 0 ? -1 : 1),
          material: material,
          ray: ray,
          time: ray.time
        )
      } else {
        return nil
      }
    }
  }
}
