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
    private(set) var initialDataLoaded: Bool = false
    private(set) var refreshingFilaments: Bool = false
    private(set) var refreshingSpools: Bool = false
    
    init(api: SpoolSenseApi) {
        self.api = api
    }
    
    func refreshFilaments() async {
        refreshingFilaments = true
        
        await api.fetchFilaments()
            .forEach { apiFilament in
                let existingFilament = filaments.first(where: { $0.id == apiFilament.id })
                
                if existingFilament != nil {
                    existingFilament?.updateFromRefresh(api: apiFilament)
                } else {
                    filaments.append(Filament(api: apiFilament))
                }
            }
        
        refreshingFilaments = false
    }
    
    func refreshSpools() async {
        refreshingSpools = true
        
        await api.fetchSpools()
            .forEach { apiSpool in
                let existingSpool = spools.first(where: { $0.id == apiSpool.id })
                let linkedFilament = filaments.first(where: { $0.id == apiSpool.filamentId })
                
                if linkedFilament != nil {
                    if existingSpool != nil {
                        existingSpool!.updateFromRefresh(api: apiSpool, filament: linkedFilament!)
                    } else {
                        spools.append(Spool(api: apiSpool, filament: linkedFilament!))
                    }
                }
            }
        
        refreshingSpools = false
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
        
        self.initialDataLoaded = true
    }
}
