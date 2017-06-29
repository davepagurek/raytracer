struct Blurrer: Absorber {
  let tintColor: Color
  let fuzziness: Scalar
  
  func scatter(_ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: (
        intersection.ray.direction + (randomVector() * fuzziness)
      ).normalized(),
      color: tintColor.multiply(intersection.ray.color),
      time: intersection.ray.time
    )
  }
}
