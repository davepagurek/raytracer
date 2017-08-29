import PackageDescription

let package = Package(
  name: "raytracer",
  targets: [
    Target(name: "VectorMath"),
    Target(name: "RaytracerLib", dependencies: ["VectorMath"]),
    Target(name: "Materials", dependencies: ["RaytracerLib", "VectorMath"]),
    Target(name: "Geometry", dependencies: ["RaytracerLib", "VectorMath", "Materials"]),
    Target(name: "Raytracer", dependencies: ["RaytracerLib", "VectorMath", "Geometry", "Materials"])
  ]
)
