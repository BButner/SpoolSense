//
// Copyright (c) 2023, Beau Butner
// All rights reserved.

// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//

import SwiftUI

enum TransactionMode: Int, CaseIterable, Identifiable {
    case consume, replenish
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .consume:
            return "Consume"
        case .replenish:
            return "Replenish"
        }
    }
    
    var color: Color {
        switch self {
        case .consume:
            return .red
        case .replenish:
            return .green
        }
    }
}

private enum Field: Int, Hashable {
    case amount, description
}

struct AddTransaction: View {
    var spool: Spool
    @Binding var isPresented: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(MainViewModel.self) private var mainContext
    @Environment(SpoolSenseApi.self) private var api
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(OverlayManager.self) private var overlayManager
    
    @State private var mode: TransactionMode = .consume
    @FocusState private var focusedField: Field?
    private let arcSize: Double = 120
    @State private var amount: Double = 0
    @State private var description: String = ""
    @State private var isLoading: Bool = false
    @State private var isFinishedAdding: Bool = false
    @State private var isErrorAdding: Bool = false
    
    var amountErrorMessage: String? {
        if amount == 0 {
            return "Please enter an amount"
        }
        
        if newPctRemaining > 1 {
            return "Amount would overfill Spool"
        }
        
        if newPctRemaining < 0 {
            return "Amount results in negative Spool value"
        }
        
        return nil
    }
    
    private var newPctRemaining: Double {
        get { return (mode == .consume ? (spool.lengthRemaining - amount) : (spool.lengthRemaining + amount)) / spool.lengthTotal }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    Spacer()
                    
                    if mode == .consume {
                        Spacer()
                    }
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            mode = .consume
                        }
                    } label: {
                        Text(TransactionMode.consume.title)
                            .font(mode == .consume ? .title : .title2)
                            .fontWeight(.semibold)
                    }
                    .tint(mode == .consume ? .indigo : .secondary)
                    .opacity(mode == .consume ? 1 : 0.5)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            mode = .replenish
                        }
                    } label: {
                        Text(TransactionMode.replenish.title)
                            .font(mode == .replenish ? .title : .title2)
                            .fontWeight(.semibold)
                    }
                    .tint(mode == .replenish ? .indigo : .secondary)
                    .opacity(mode == .replenish ? 1 : 0.7)
                    
                    if mode == .replenish {
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 52)
                
                VStack(spacing: 32) {
                    ZStack {
                        ArcView(
                            length: arcSize,
                            endAngle: .degrees(360.0),
                            style: .indigo.opacity(0.2),
                            strokeLineWidth: 12
                        )
                        
                        ArcView(
                            length: arcSize,
                            endAngle: mode == .consume ? .degrees((360.0 * spool.remainingPct())) : .degrees(360.0 * newPctRemaining),
                            style: mode == .consume ? .red : .green,
                            strokeLineWidth: 12
                        )
                        
                        ArcView(
                            length: arcSize,
                            endAngle: mode == .replenish ? .degrees((360.0 * spool.remainingPct())) : .degrees(360.0 * newPctRemaining),
                            style: .indigo,
                            strokeLineWidth: 12
                        )
                        .animation(.interactiveSpring, value: amount)
                        
                        Text(spool.remainingPct().rounded(.down) == 1 ? "Full" : "\((spool.remainingPct() * 100).rounded().formatted())%")
                            .fontWeight(.bold)
                    }
                    .frame(width: arcSize, height: arcSize)
                    
                    VStack(spacing: 14) {
                        Text(spool.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("\(spool.filament.brand) - \(spool.filament.name)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack {
                        Text(amountErrorMessage == nil ? " " : amountErrorMessage!)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .animation(.easeInOut, value: amountErrorMessage)
                        
                        HStack(alignment: .lastTextBaseline) {
                            HStack {
                                Image(systemName: mode == .consume ? "minus" : "plus")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .frame(width: 24)
                                
                                TextField("0", value: $amount, formatter: NumberFormatterConstants.emptyZeroFormatter())
                                    .focused($focusedField, equals: .amount)
                                    .fixedSize()
                                    .font(.system(size: 42))
                                    .fontWeight(.semibold)
                                    .keyboardType(.decimalPad)
                                    .textSelection(.disabled)
                            }
                            
                            Text("m")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.indigo)
                        }
                    }
                    
                    TextFieldString(header: "Description", title: "What's this for?", text: $description, isInvalid: description.isEmpty, errorMessage: "cannot be empty")
                }
                
                Spacer()
                
                DragConfirm(text: "Swipe to Submit", isLoading: $isLoading, isComplete: $isFinishedAdding, isError: $isErrorAdding, successView: AnyView(successView()), errorView: AnyView(errorView()))
                    .onChange(of: isLoading) {
                        Task {
                            let transaction = Transaction(
                                userId: mainContext.session!.user.id,
                                spoolId: spool.id,
                                type: TransactionType.manual,
                                date: Date.now,
                                amount: mode == .consume ? -amount : amount,
                                description: description
                            )
                            
                            let result = await api.insertTransaction(transaction: transaction.toApi())
                            
                            // TODO: There should really be an error message here
                            isFinishedAdding = result
                        }
                    }
                    .disabled(amountErrorMessage != nil || description.isEmpty || mainContext.session == nil)
            }
            .animation(.easeInOut, value: isLoading)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            focusedField = .amount
        }
    }
}

extension AddTransaction {
    var keyWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes.lazy
            .compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }
            .first(where: { $0.keyWindow != nil })?
            .keyWindow
    }
    
    func successView() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Text("Transaction Added")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Spacer()
            
            Button("Done") {
                overlayManager.dequeueOverlay()
                self.presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.bordered)
            .tint(.white)
        }
    }
    
    func errorView() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Text("Error Adding Transaction")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Spacer()
            
            Button("Done") {
                overlayManager.dequeueOverlay()
                self.presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.bordered)
            .tint(.white)
        }
    }
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    @State var overlayManager = OverlayManager()
    
    return AddTransaction(spool: SpoolConstants.demoSpoolOrange, isPresented: .constant(true))
        .environment(api)
        .environment(mainContext)
        .environment(overlayManager)
        .task {
            await mainContext.loadInitialData()
        }
}
