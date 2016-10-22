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
