struct Reflective: Absorber {
  let tintColor: Color
  let fuzziness: Scalar
  
  func scatter(_ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: (
        intersection.ray.direction.reflectAround(intersection.normal)
          + (randomVector() * fuzziness)
        ).normalized(),
      color: tintColor.multiply(intersection.ray.color),
      time: intersection.ray.time
    )
  }
}
