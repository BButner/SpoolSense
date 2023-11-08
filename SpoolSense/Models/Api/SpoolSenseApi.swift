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
            return try await client.auth.getOAuthSignInURL(provider: provider, redirectTo: URL(string: "spoolsense://auth-callback")!)
        } catch {
            print("### Google Sign in Error: \(error)")
            return nil
        }
    }
    
    func insertSpool(spool: SpoolApi) async -> Bool {
        do {
            let query = try await client.database
                .from("spools_dev")
                .insert(values: spool, returning: .representation)
                .select()
                .single()
            
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
                        
            filaments.append(contentsOf: default_filaments)
            
            return filaments
        } catch {
            print("Error when Fetching Filaments: \(error)")
            
            return []
        }
    }
    
    func fetchSpools() async -> [SpoolApi] {
        do {
            let query = await client.database
                .from("spools_dev")
                .select()
            
            let response: [SpoolApi] = try await query.execute().value
            
            return response
        } catch {
            print("Error when Fetching Spools: \(error) | \(error.localizedDescription)")
            
            return []
        }
    }
    
    func fetchSpoolLengthRemaining(spoolId: UUID) async -> Double {
        do {
            let query = try await client.database.rpc(fn: "get_spool_length_remaining_dev", params: GetSpoolLengthRemainingParams(p_spool_id: spoolId))
            
            let response: Double = try await query.execute().value
            
            return response
        } catch {
            print("Error when Fetching Spools: \(error) | \(error.localizedDescription)")
            
            return -1.0
        }
    }
    
    func insertTransaction(transaction: TransactionApi) async -> Bool {
        do {
            let query = try await client.database
                .from("transactions_dev")
                .insert(values: transaction, returning: .representation)
                .select()
                .single()
            
            let response: TransactionApi = try await query.execute().value
            return response.id == transaction.id
        } catch {
            print("Error when Inserting Transaction: \(error)")
            return false
        }
    }
}
