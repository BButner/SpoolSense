//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value, Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                handler(self.wrappedValue, newValue)
                self.wrappedValue = newValue
            }
        )
    }
}
