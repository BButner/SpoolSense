//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation

struct MathUtil {
    static func mapValueToRange(value: Double, originalRange: (min: Double, max: Double), targetRange: (min: Double, max: Double)) -> Double {
        return targetRange.min + (value - originalRange.min) / (originalRange.max - originalRange.min) * (targetRange.max - targetRange.min)
    }
}
