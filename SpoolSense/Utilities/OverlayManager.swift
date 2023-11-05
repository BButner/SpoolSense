//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import SwiftUI

struct OverlayItem: Identifiable, Equatable {
    static func == (lhs: OverlayItem, rhs: OverlayItem) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let content: AnyView
}

@Observable
class OverlayManager {
    var overlayQueue: [OverlayItem] = [OverlayItem]()
    
    var currentOverlay: OverlayItem? {
        overlayQueue.first
    }
    
    func enqueueOverlay(overlay: OverlayItem) {
        overlayQueue.append(overlay)
    }
    
    func dequeueOverlay() {
        if !overlayQueue.isEmpty {
            overlayQueue.removeFirst()
        }
    }
}
