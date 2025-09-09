//
//  ContentView.swift
//  Trench Assistant
//

import SwiftUI

struct ContentView: View {
    @State private var numDice = 2
    @State private var keep = 2
    @State private var armour = 0
    @State private var bonus = 0
    @State private var results: [String: Double] = [:]
    
    // Formatting for the outcomes.
    let outcomeOrder = ["No Effect", "Minor Hit", "Down", "Out of Action"]
    let outcomeColors: [String: Color] = [
        "No Effect": .green,
        "Minor Hit": .blue,
        "Down": .purple,
        "Out of Action": .red
    ]
    
    var body: some View {
        ZStack {
            // Dark grey background.
            Color(.darkGray)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("Trench Dice Calculator")
                    .font(.system(size: 30, weight: .bold))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)
                
                // MARK: Select a number of dice, cannot go below 1 or above 7.
                HStack {
                    Button(action: { if numDice > 1 { numDice -= 1 } }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    .disabled(numDice <= 1)
                    
                    Text("\(numDice)d6")
                        .font(.system(size: 36, weight: .bold))
                        .frame(minWidth: 100)
                        .foregroundColor(.white)
                    
                    Button(action: { if numDice < 7 { numDice += 1 } }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    .disabled(numDice >= 7)
                }
                .padding()
                
                // MARK: Select armour value (-3 -> 0)
                HStack(spacing: 5) {
                    Text("Armour")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)
                    ForEach([0, 1, 2, 3], id: \.self) { value in
                        let label = value == 0 ? "0" : "-\(value)"
                        Button(action: {
                            armour = value
                        }) {
                            Text(label)
                                .font(.system(size: 23, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 16)
                                .background(armour == value ? Color.red : Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                    }
                }

                // MARK: Select bonus value (+0 -> +6)
                HStack(spacing: 5) {
                    Text("Bonus")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)
                    ForEach([0, 1, 2, 3, 4, 5, 6], id: \.self) { value in
                        let label = value == 0 ? "0" : "+\(value)"
                        Button(action: {
                            bonus = value
                        }) {
                            Text(label)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 6)
                                .background(bonus == value ? Color.red : Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                    }
                }
                
                // MARK: Select how many dice to keep, 2d6 or 3d6.
                HStack(spacing: 5) {
                    Text("Sum")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)
                    ForEach([2, 3], id: \.self) { value in
                        let label = value == 0 ? "0" : "\(value)d6"
                        Button(action: {
                            keep = value
                        }) {
                            Text(label)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(keep == value ? Color.red : Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                    }
                }
                /** Don't need this anymore?
                // MARK: Button to calculate the results.
                 Button("Calculate") {
                    results = DiceEngine.calculateProbabilities(
                        n: numDice,
                        keep: keep,
                        armour: armour,
                        bonus: bonus
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                 */
                
                // MARK: Output the results.
                if !results.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(outcomeOrder, id: \.self) { key in
                            if let value = results[key] {
                                HStack {
                                    Text(key)
                                        .frame(width: 100, alignment: .leading)
                                        .foregroundColor(.white)
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 20)
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(outcomeColors[key] ?? .black)
                                            .frame(width: CGFloat(value) * 2, height: 20)
                                    }
                                    Text(String(format: "%.1f%%", value))
                                        .frame(width: 50, alignment: .trailing)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.3)))
                }
                
                Spacer()
            }
            .padding()
            
            // Recalculate whenever any state changes.
            .onChange(of: numDice) { _ in recalc() }
            .onChange(of: keep) { _ in recalc() }
            .onChange(of: armour) { _ in recalc() }
            .onChange(of: bonus) { _ in recalc() }
            .onAppear { recalc() }
        }
    }
    private func recalc() {
        results = DiceEngine.calculateProbabilities(
            n: numDice,
            keep: keep,
            armour: armour,
            bonus: bonus
        )
    }
}
