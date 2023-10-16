//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import Supabase

@Observable
final class SpoolSenseApi {
    private let client: SupabaseClient
    
    init() {
        print("Init of Supabase Client")
        self.client = SupabaseClient(supabaseURL: URL(string: "https://dwuykowhnylkzrvithkv.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3dXlrb3dobnlsa3pydml0aGt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTcwNjE2OTUsImV4cCI6MjAxMjYzNzY5NX0.-XLbIPmfK4UDhQSjr_fQVEPscZQK3q8dUzySceQrH2k")
    }
    
    func fetchFilaments() async -> [FilamentApi] {
        do {
            return try await client.database.from("filaments_dev")
                .select()
                .execute()
                .value
        } catch {
            print("Error when Fetching Filaments: \(error)")
            
            return []
        }
    }
    
    func fetchSpools() async -> [SpoolApi] {
        do {
            return try await client.database.from("spools_dev")
                .select()
                .execute()
                .value
        } catch {
            print("Error when Fetching Spools: \(error)")
            
            return []
        }
    }
}
