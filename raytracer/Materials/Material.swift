protocol Material {
  // Returns scattered ray, and whether the ray has reached a light source
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool)
}

protocol Absorber: Material {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool)
}

extension Absorber {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool) {
    return (scatter(ray, intersection), false)
  }
}

protocol Emitter: Material {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool)
}

extension Emitter {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool) {
    return (scatter(ray, intersection), true)
  }
}
