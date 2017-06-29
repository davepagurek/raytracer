protocol Surface {
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection?
}

protocol FiniteSurface: Surface {
  func boundingBox() -> BoundingBox
}

protocol ContainedSurface: FiniteSurface {
  func containsPoint(_ point: Vector4) -> Bool
  func normalAt(_ point: Vector4) -> Vector4
}

extension Surface {
  func intersectsRay(_ ray: Ray) -> Intersection? {
    return intersectsRay(ray, min: 0.0001, max: Scalar.infinity)
  }
  
  func bounce(_ ray: Ray) -> (Ray, Bool)? {
    if let intersection = intersectsRay(ray) {
      return intersection.material.scatter(intersection)
    }
    return nil
  }
}
