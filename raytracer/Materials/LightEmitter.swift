struct LightEmitter: Emitter {
  let tintColor: Color
  let brightness: Scalar
  
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: intersection.normal,
      color: Color(
        r: tintColor.r * ray.color.r * brightness,
        g: tintColor.g * ray.color.g * brightness,
        b: tintColor.b * ray.color.b * brightness
      )
    )
  }
}
