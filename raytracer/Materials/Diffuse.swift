struct Diffuse: Absorber {
  let color: Color
  let reflectivity: Scalar
  
  func scatter(_ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: intersection.normal + randomVector(),
      color: Color(
        r: reflectivity * (intersection.ray.color.r * color.r),
        g: reflectivity * (intersection.ray.color.g * color.g),
        b: reflectivity * (intersection.ray.color.b * color.b)
      ),
      time: intersection.ray.time
    )
  }
}
