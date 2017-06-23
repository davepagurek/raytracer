struct SkinnedVolume: ContainedSurface {
  let volume: Volume
  let skin: Material
  let probability: Scalar
  
  func containsPoint(_ point: Vector4) -> Bool {
    return volume.containsPoint(point)
  }
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    
  }
}
