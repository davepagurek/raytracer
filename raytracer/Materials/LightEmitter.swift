struct LightEmitter: Emitter {
  let tintColor: Color
  let brightness: Scalar
  
  func scatter(_ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: intersection.normal,
      color: Color(
        r: tintColor.r * intersection.ray.color.r * brightness,
        g: tintColor.g * intersection.ray.color.g * brightness,
        b: tintColor.b * intersection.ray.color.b * brightness
      ),
      time: intersection.ray.time
    )
  }
}
