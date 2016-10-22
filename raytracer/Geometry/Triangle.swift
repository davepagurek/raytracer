struct Triangle: Surface {
  let anchor: Vector4
  let normal, u, v: Vector4
  let material: Material
  
  init(a: Vector4, b: Vector4, c: Vector4, material: Material) {
    anchor = a
    u = b - a
    v = c - a
    let n = u.xyz.cross(v.xyz)
    normal = Vector(x: n.x, y: n.y, z: n.z)
    self.material = material
  }
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    let pointOnPlane: Vector4?
    if ray.direction.dot(normal) ~= 0 {
      pointOnPlane = ray.point
    } else {
      let t = (anchor - ray.point).dot(normal) / ray.direction.dot(normal)
      
      if t >= min && t <= max {
        pointOnPlane = ray.point + ray.direction*t
      } else {
        pointOnPlane = nil
      }
    }
    
    if let p = pointOnPlane {
      let w = p - anchor
      let denom = u.dot(v)*u.dot(v) - (u.dot(u)*v.dot(v))
      let s = (u.dot(v)*w.dot(v) - (v.dot(v)*w.dot(u)))/denom
      let t = (u.dot(v)*w.dot(u) - (u.dot(u)*w.dot(v)))/denom
      if s >= 0 && t >= 0 && s+t <= 1 {
        return Intersection(
          point: p,
          normal: normal * (ray.direction.dot(normal) > 0 ? -1 : 1),
          material: material,
          time: ray.time
        )
      }
    }
    return nil
  }
}
