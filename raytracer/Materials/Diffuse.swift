struct Diffuse: Absorber {
  let color: Color
  let reflectivity: Scalar
  
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: intersection.normal + randomVector(),
      color: Color(
        r: reflectivity * (ray.color.r * color.r),
        g: reflectivity * (ray.color.g * color.g),
        b: reflectivity * (ray.color.b * color.b)
      ),
      time: ray.time
    )
  }
}
