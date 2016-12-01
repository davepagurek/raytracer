struct SurfaceList: FiniteSurface {
  let surfaces: [FiniteSurface]
  let box: BoundingBox
  let sphere: BoundingSphere
  
  init(surfaces: [FiniteSurface]) {
    self.surfaces = surfaces
    box = BoundingBox(from: surfaces.map{$0.boundingBox()})
    sphere = box.boundingSphere()
  }
  
  func boundingBox() -> BoundingBox {
    return box
  }
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    if !sphere.intersectsRay(ray, min: min, max: max) {
      return nil
    }
    
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

struct UnboundedSurfaceList: Surface {
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
