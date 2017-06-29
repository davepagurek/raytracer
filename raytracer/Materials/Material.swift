protocol Material {
  // Returns scattered ray, and whether the ray has reached a light source
  func scatter(_ intersection: Intersection) -> (Ray, Bool)
}

protocol Absorber: Material {
  func scatter(_ intersection: Intersection) -> Ray
  func scatter(_ intersection: Intersection) -> (Ray, Bool)
}

extension Absorber {
  func scatter(_ intersection: Intersection) -> (Ray, Bool) {
    return (scatter(intersection), false)
  }
}

protocol Emitter: Material {
  func scatter(_ intersection: Intersection) -> Ray
  func scatter(_ intersection: Intersection) -> (Ray, Bool)
}

extension Emitter {
  func scatter(_ intersection: Intersection) -> (Ray, Bool) {
    return (scatter(intersection), true)
  }
}
