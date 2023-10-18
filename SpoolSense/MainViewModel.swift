//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import Supabase

@Observable
final class MainViewModel {
    let api: SpoolSenseApi
    var filaments = [Filament]()
    var spools = [Spool]()
    var session: Session?
    
    init(api: SpoolSenseApi) {
        self.api = api
    }
    
    func loginWithGoogle() async {
        
    }
    
    func loadInitialData() async {
        await api.fetchFilaments().map { Filament(api: $0) }
            .forEach {
                self.filaments.append($0)
            }
        
        await api.fetchSpools().compactMap { spool in
            let linkedFilament = self.filaments.first { $0.id == spool.filamentId }
            
            if linkedFilament == nil {
                return nil
            }
            
            return Spool(api: spool, filament: linkedFilament!)
        }.forEach {
            self.spools.append($0)
        }
    }
}
