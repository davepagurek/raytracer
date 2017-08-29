import VectorMath

public struct Keyframe {
  let time: Scalar
  let transformation: Matrix4

  public init(time: Scalar, transformation: Matrix4) {
    self.time = time
    self.transformation = transformation
  }
}

public struct TransformSteps {
  let frames: [Keyframe]
  
  public init(frames: [Scalar: Matrix4]) {
    self.frames = frames
      .map{(t,m) in Keyframe(time: t, transformation: m)}
      .sorted{(a, b) in a.time < b.time}
  }
  
  private func endIndexFor(_ t: Scalar) -> Int {
    var low: Int = 0
    var high: Int = frames.count - 1
    while low != high {
      let mid = low + ((high - low) / 2)
      if frames[mid].time < t {
        low = mid + 1
      } else {
        high = mid
      }
    }
    return low
  }
  
  public func at(_ t: Scalar) -> Matrix4 {
    let endIndex = capHigh(endIndexFor(t), frames.count-1)
    let startIndex = capLow(endIndex-1, 0)
    
    if endIndex == startIndex {
      return frames[endIndex].transformation
    } else {
      return frames[startIndex].transformation.blend(
        frames[endIndex].transformation,
        (t - frames[startIndex].time)/(frames[endIndex].time - frames[startIndex].time)
      )
    }
  }
}
