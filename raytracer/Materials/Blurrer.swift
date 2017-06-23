struct Blurrer: Absorber {
  let tintColor: Color
  let fuzziness: Scalar
  
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: (
        ray.direction + (randomVector() * fuzziness)
      ).normalized(),
      color: Color(
        r: tintColor.r * ray.color.r,
        g: tintColor.g * ray.color.g,
        b: tintColor.b * ray.color.b
      ),
      time: ray.time
    )
  }
}
