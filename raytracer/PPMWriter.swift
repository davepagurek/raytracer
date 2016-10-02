//
//  PPMWriter.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 10/1/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

struct Color {
  let r, g, b: Int
}

extension Color {
  init(_ hex: Int) {
    self.init(
      r: (hex >> 16) & 0xFF,
      g: (hex >> 8) & 0xFF,
      b: hex & 0xFF
    )
  }
}

func writePPM(file: String, pixels: [[Color]]) {
    try! ("P3\n" +
      "\(pixels.first?.count ?? 0) \(pixels.count)\n" +
      "255\n" +
      pixels.map { (row: [Color]) -> String in
        return row.map { (c: Color) -> String in
          return "\(c.r) \(c.g) \(c.b)"
          }.joined(separator: "\n")
        }.joined(separator: "\n")
      ).write(toFile: file, atomically: true, encoding: String.Encoding.utf8)
}
