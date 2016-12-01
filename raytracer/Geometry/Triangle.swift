struct Triangle: FiniteSurface {
  let anchor: Vector4
  let normal, u, v: Vector4
  let material: Material
  let box: BoundingBox
  let sphere: BoundingSphere
  
  init(a: Vector4, b: Vector4, c: Vector4, material: Material) {
    anchor = a
    u = b - a
    v = c - a
    let n = u.xyz.cross(v.xyz)
    normal = Vector(x: n.x, y: n.y, z: n.z)
    self.material = material
    
    box = BoundingBox(
      minCorner: Vector(
        x: min(a.x, b.x, c.x),
        y: min(a.y, b.y, c.y),
        z: min(a.z, b.z, c.z)
      ),
      maxCorner: Vector(
        x: max(a.x, b.x, c.x),
        y: max(a.y, b.y, c.y),
        z: max(a.z, b.z, c.z)
      )
    )
    sphere = box.boundingSphere()
  }
  
  func boundingBox() -> BoundingBox {
    return box;
  }
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    if !sphere.intersectsRay(ray, min: min, max: max) {
      return nil
    }
    
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

// a, b, c, d in order
func Rectangle(a: Vector4, b: Vector4, c: Vector4, d: Vector4, material: Material) -> FiniteSurface {
  return SurfaceList(surfaces: [
    Triangle(a: a, b: b, c: c, material: material),
    Triangle(a: c, b: d, c: a, material: material)
  ])
}

func RectPrism(location: Vector4, w: Scalar, h: Scalar, d: Scalar, material: Material) -> FiniteSurface {
  return SurfaceList(surfaces: [
    // front
    Rectangle(
      a: location + Point(x: -w/2, y: h/2, z: d/2),
      b: location + Point(x: w/2, y: h/2, z: d/2),
      c: location + Point(x: w/2, y: -h/2, z: d/2),
      d: location + Point(x: -w/2, y: -h/2, z: d/2),
      material: material
    ),
    // back
    Rectangle(
      a: location + Point(x: -w/2, y: h/2, z: -d/2),
      b: location + Point(x: w/2, y: h/2, z: -d/2),
      c: location + Point(x: w/2, y: -h/2, z: -d/2),
      d: location + Point(x: -w/2, y: -h/2, z: -d/2),
      material: material
    ),
    // right
    Rectangle(
      a: location + Point(x: w/2, y: h/2, z: -d/2),
      b: location + Point(x: w/2, y: h/2, z: d/2),
      c: location + Point(x: w/2, y: -h/2, z: d/2),
      d: location + Point(x: w/2, y: -h/2, z: -d/2),
      material: material
    ),
    // left
    Rectangle(
      a: location + Point(x: -w/2, y: h/2, z: -d/2),
      b: location + Point(x: -w/2, y: h/2, z: d/2),
      c: location + Point(x: -w/2, y: -h/2, z: d/2),
      d: location + Point(x: -w/2, y: -h/2, z: -d/2),
      material: material
    ),
    // top
    Rectangle(
      a: location + Point(x: w/2, y: -h/2, z: -d/2),
      b: location + Point(x: w/2, y: -h/2, z: d/2),
      c: location + Point(x: -w/2, y: -h/2, z: d/2),
      d: location + Point(x: -w/2, y: -h/2, z: -d/2),
      material: material
    ),
    // bottom
    Rectangle(
      a: location + Point(x: w/2, y: h/2, z: -d/2),
      b: location + Point(x: w/2, y: h/2, z: d/2),
      c: location + Point(x: -w/2, y: h/2, z: d/2),
      d: location + Point(x: -w/2, y: h/2, z: -d/2),
      material: material
    )
  ])
}
