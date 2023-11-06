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
                HStack {
                    Spacer()
                    
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    .tint(.secondary)
                }
                
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
            }
            .padding(.bottom, 68)
            .disabled(isLoading)
            .opacity(isLoading ? 0.2 : 1)
            .animation(.easeInOut, value: isLoading)
            
            GeometryReader() { proxy in
                Circle()
                    .fill(.indigo)
                    .opacity(isFinishedAdding ? 1 : 0)
                    .frame(width: isFinishedAdding ? (keyWindow?.screen.bounds.width ?? 0) * 4.0 : 0, height: isFinishedAdding ? (keyWindow?.screen.bounds.height ?? 0) * 2.0 : 0)
                    .animation(.snappy(duration: 0.3, extraBounce: 0.2), value: isFinishedAdding)
                    .animation(.snappy(duration: 0.1, extraBounce: 0.2), value: isPresented)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
            }
            .clipped()
            .ignoresSafeArea()
            
            GeometryReader() { geometry in
                ZStack {
                    ZStack(alignment: isLoading ? .center : .bottom) {
                        VStack(spacing: 0) {
//                            DragConfirm(text: "Swipe to Submit", isLoading: $isLoading, isComplete: $isFinishedAdding, isError: $isErrorAdding)
//                                .padding(.horizontal)
//                                .padding(.bottom)
//                                .onChange(of: isLoading) {
//                                    Task {
//                                        let transaction = Transaction(
//                                            userId: mainContext.session!.user.id,
//                                            spoolId: spool.id,
//                                            type: TransactionType.manual,
//                                            date: Date.now,
//                                            amount: mode == .consume ? -amount : amount,
//                                            description: description
//                                        )
//                                        
//                                        let result = await api.insertTransaction(transaction: transaction.toApi())
//                                        
//                                        // TODO: There should really be an error message here
//                                        isFinishedAdding = result
//                                    }
//                                }
//                                .frame(width: geometry.size.width)
//                                .disabled(amountErrorMessage != nil || description.isEmpty || mainContext.session == nil)
                        }
                    }
                    .fixedSize()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: isLoading ? .center : .bottom)
                    
                    if isFinishedAdding {
                        VStack {
                            Spacer()
                                                        
                            Text("Transaction Added")
                                .foregroundStyle(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .opacity(isFinishedAdding ? 1 : 0)
                                .animation(.snappy(duration: 0.3, extraBounce: 0.2), value: isFinishedAdding)
                            
                            Spacer()
                            
                            Spacer()
                            
                            Button {
                                isPresented = false
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Done")
                                        .font(.title2)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                            .tint(.white)
                        }
                    }
                }
                .fixedSize()
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
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
}

#Preview {
    @State var api = SpoolSenseApi()
    @State var mainContext = MainViewModel(api: api)
    
    return AddTransaction(spool: SpoolConstants.demoSpoolOrange, isPresented: .constant(true))
        .environment(api)
        .environment(mainContext)
        .task {
            await mainContext.loadInitialData()
        }
}
