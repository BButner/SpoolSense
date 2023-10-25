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

struct AddTransaction: View {
    var spool: Spool
    @Environment(\.colorScheme) private var colorScheme
    @State private var mode: TransactionMode = .consume
    @State private var transactionAmount: String = "0"
    @FocusState private var isFocused: Bool
    private let arcSize: Double = 180
    
    @State private var amount: Double = 0
    
    private var newPctRemaining: Double {
        get { return (mode == .consume ? (spool.lengthRemaining - amount) : (spool.lengthRemaining + amount)) / spool.lengthTotal }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                }
            }
        }
//        VStack(alignment: .center, spacing: 0) {
//            Text("Spool Transaction")
//                .font(.title)
//                .fontWeight(.semibold)
//                .padding()
//            
//            Picker("", selection: $mode) {
//                ForEach(TransactionMode.allCases) { transactionMode in
//                    Text(transactionMode.title).tag(transactionMode)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding(.horizontal)
//            .padding(.top)
//            
//            Spacer()
//            
//            HStack {
//                Image(systemName: mode == .consume ? "minus" : "plus")
//                    .font(.title)
//                    .foregroundStyle(mode == .consume ? .red : .green)
//                    .fontWeight(.bold)
//                    .animation(.easeInOut, value: mode)
//                    .frame(width: 24)
//                
//                Text("\(transactionAmount)m")
//                    .font(.system(size: 42))
//                    .foregroundStyle(mode == .consume ? .red : .green)
//                    .fontWeight(.semibold)
//                    .animation(.easeInOut, value: mode)
//            }
//            .shadow(color: mode == .consume ? .red.opacity(0.2) : .green.opacity(0.2), radius: 10)
//            
//            Spacer()
//            
//            ZStack {
//                ArcView(
//                    length: arcSize,
//                    endAngle: mode == .consume ? .degrees((360.0 * spool.remainingPct())) : .degrees(360.0 * newPctRemaining),
//                    style: mode == .consume ? .red : .green,
//                    strokeLineWidth: 16
//                )
//                
//                ArcView(
//                    length: arcSize,
//                    endAngle: mode == .replenish ? .degrees((360.0 * spool.remainingPct())) : .degrees(360.0 * newPctRemaining),
//                    style: .indigo,
//                    strokeLineWidth: 16
//                )
//                .animation(.interactiveSpring, value: amount)
//                
//                Text(spool.remainingPct().rounded(.down) == 1 ? "Full" : "\((spool.remainingPct() * 100).rounded().formatted())%")
//                    .fontWeight(.bold)
//            }
//            .frame(width: arcSize, height: arcSize)
//            
//            Spacer()
//            
//            VStack {
//                HStack {
//                    Spacer()
//                    numberButton(text: "1")
//                    numberButton(text: "2")
//                    numberButton(text: "3")
//                    Spacer()
//                }
//                HStack {
//                    Spacer()
//                    numberButton(text: "4")
//                    numberButton(text: "5")
//                    numberButton(text: "6")
//                    Spacer()
//                }
//                HStack {
//                    Spacer()
//                    numberButton(text: "7")
//                    numberButton(text: "8")
//                    numberButton(text: "9")
//                    Spacer()
//                }
//                HStack {
//                    Spacer()
//                    numberButton(text: ".")
//                    numberButton(text: "0")
//                    Button {
//                        transactionAmount = String(transactionAmount.dropLast())
//                        
//                        if transactionAmount.isEmpty {
//                            transactionAmount = "0"
//                        }
//                        
//                        amount = Double(transactionAmount)!
//                        
//                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                        impactMed.impactOccurred()
//                    } label: {
//                        Image(systemName: "delete.left")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .frame(width: 50, height: 40)
//                            .foregroundStyle(colorScheme == .dark ? .white : .black)
//                    }
//                    .padding(.horizontal)
//                    .buttonStyle(.borderedProminent)
//                    .tint(colorScheme == .dark ? .black : .white)
//                    .buttonRepeatBehavior(.enabled)
//                    Spacer()
//                }
//            }
//            .padding(.top)
//        }
//        .padding(.top)
    }
}

extension AddTransaction {
    func numberButton(text: String) -> some View {
        Button {
            if transactionAmount == "0" && text != "." {
                transactionAmount = text
            } else {
                let newValue = Double("\(transactionAmount)\(text)")
                
                if newValue != nil {
                    transactionAmount = transactionAmount + text
                }
            }
            
            amount = Double(transactionAmount)!
            
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        } label: {
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
                .frame(width: 50, height: 50)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
        .buttonStyle(.borderedProminent)
        .tint(colorScheme == .dark ? .black : .white)
        .padding(.horizontal)
    }
}

#Preview {
    AddTransaction(spool: SpoolConstants.demoSpoolOrange)
}
