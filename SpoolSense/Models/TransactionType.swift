//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation

enum TransactionType: Int, Codable {
    case refill = 0
    case manual = 1
    case printManual = 2
    case printApi = 3
}
