protocol Surface {
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection?
}

protocol FiniteSurface: Surface {
  func boundingBox() -> BoundingBox
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
