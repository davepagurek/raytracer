import Foundation

protocol Surface {
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection?
}

extension Surface {
  func intersectsRay(_ ray: Ray) -> Intersection? {
    return intersectsRay(ray, min: 0.0001, max: Scalar.infinity)
  }
  
  func bounce(_ ray: Ray) -> (Ray, Bool)? {
    if let intersection = intersectsRay(ray) {
      return intersection.material.scatter(ray, intersection)
    }
    return nil
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

struct InfinitePlane: Surface {
  let anchor: Vector4
  let normal: Vector4
  let material: Material
  
  init(anchor: Vector4, normal: Vector4, material: Material) {
    self.anchor = anchor
    self.normal = normal.normalized()
    self.material = material
  }
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    if ray.direction.dot(normal) ~= 0 {
      return Intersection(point: ray.point, normal: normal, material: material)
    } else {
      let t = (anchor - ray.point).dot(normal) / ray.direction.dot(normal)
      
      if t >= min && t <= max {
        return Intersection(
          point: ray.point + ray.direction*t,
          normal: normal * (ray.direction.dot(normal) > 0 ? -1 : 1),
          material: material
        )
      } else {
        return nil
      }
    }
  }
}


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
          material: material
        )
      }
    }
    return nil
  }
}

