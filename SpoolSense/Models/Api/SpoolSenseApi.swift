//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//


import Foundation
import Supabase
import GoTrue

@Observable
final class SpoolSenseApi {
    private let client: SupabaseClient
    
    init() {
        self.client = SupabaseClient(supabaseURL: URL(string: "https://dwuykowhnylkzrvithkv.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3dXlrb3dobnlsa3pydml0aGt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTcwNjE2OTUsImV4cCI6MjAxMjYzNzY5NX0.-XLbIPmfK4UDhQSjr_fQVEPscZQK3q8dUzySceQrH2k")
    }
    
    func getSession() async -> Session? {
        do {
            let session = try await client.auth.session
            
            return session
        } catch {
            print("### oAuthCallback error: \(error)")
            return nil
        }
    }
    
    func getSessionFromUrl(url: URL) async -> Session? {
        do {
            let session = try await client.auth.session(from: url)
            
            return session
        } catch {
            print("### oAuthCallback error: \(error)")
            return nil
        }
    }
    
    func getOAuthSignInURL(provider: Provider) async -> URL? {
        do {
            return try client.auth.getOAuthSignInURL(provider: provider, redirectTo: URL(string: "spoolsense://auth-callback")!)
        } catch {
            print("### Google Sign in Error: \(error)")
            return nil
        }
    }
    
    func insertSpool(spool: SpoolApi) async -> Bool {
        let query = client.database
            .from("spools_dev")
            .insert(values: spool, returning: .representation)
            .select()
            .single()
        
        do {
            let response: SpoolApi = try await query.execute().value
            return response.id == spool.id
        } catch {
            print("Error when Inserting Spool: \(error)")
            return false
        }
    }
    
    func fetchFilaments() async -> [FilamentApi] {
        do {
            var filaments: [FilamentApi] = try await client.database.from("filaments_dev")
                .select()
                .execute()
                .value
            
            let default_filaments: [FilamentApi] = try await client.database.from("filaments_default")
                .select()
                .execute()
                .value
            
            print("Default Filaments: \(default_filaments)")
            
            filaments.append(contentsOf: default_filaments)
            
            return filaments
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
