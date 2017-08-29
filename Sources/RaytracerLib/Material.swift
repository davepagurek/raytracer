import VectorMath

public protocol Material {
  // Returns scattered ray, and whether the ray has reached a light source
  func scatter(_ intersection: Intersection) -> (Ray, Bool)
}

public protocol Absorber: Material {
  func scatter(_ intersection: Intersection) -> Ray
  func scatter(_ intersection: Intersection) -> (Ray, Bool)
}

extension Absorber {
  public func scatter(_ intersection: Intersection) -> (Ray, Bool) {
    return (scatter(intersection), false)
  }
}

public protocol Emitter: Material {
  func scatter(_ intersection: Intersection) -> Ray
  func scatter(_ intersection: Intersection) -> (Ray, Bool)
}

extension Emitter {
  public func scatter(_ intersection: Intersection) -> (Ray, Bool) {
    return (scatter(intersection), true)
  }
}
