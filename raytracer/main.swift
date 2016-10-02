//
//  main.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 9/30/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

writePPM(
  file: "test.ppm",
  pixels: Raytracer(
    width: 4,
    height: 2,
    distance: 1,
    objects: [
      Sphere(
        center: Point(x: 0, y: 0, z: -1),
        radius: 0.5
      )
    ]
  ).render(
    w: 200,
    h: 100
  )
)

/*
 (0...255).map{ (x: Int) in
 return (0...255).map{ (y: Int) in
 return Color(r: x, g: y, b: 40)
 }
 }
 */
print("Done!")
