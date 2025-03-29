import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var memory: Double = 0.0
    @State private var history: [String] = []
    @State private var showHistory = false
    @State private var isMemoryStored = false  // State property to track if something is stored in memory
    @State private var lastOperator: String? = nil  // Track the last operator used
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    showHistory.toggle()
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                Spacer()
            }
            
            if showHistory {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(history, id: \.self) { entry in
                            Text(entry)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            } else {
                Text(display)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                VStack(spacing: 10) {
                    HStack {
                        MemoryButton(label: "M+", action: memoryAdd)
                        MemoryButton(label: "M-", action: memorySubtract)
                        MemoryButton(label: "MC", action: memoryClear)
                        MemoryButton(label: "MR", isEnabled: isMemoryStored, action: memoryRecall)
                    }
                    HStack {
                        CalculatorButton(label: "⌫", action: backspace)
                        CalculatorButton(label: "+/-", action: toggleSign)
                        CalculatorButton(label: "%", action: calculatePercentage)
                        CalculatorButton(label: "/", action: { addOperation("/") })
                    }
                    HStack {
                        CalculatorButton(label: "7", action: { addDigit("7") })
                        CalculatorButton(label: "8", action: { addDigit("8") })
                        CalculatorButton(label: "9", action: { addDigit("9") })
                        CalculatorButton(label: "*", action: { addOperation("*") })
                    }
                    HStack {
                        CalculatorButton(label: "4", action: { addDigit("4") })
                        CalculatorButton(label: "5", action: { addDigit("5") })
                        CalculatorButton(label: "6", action: { addDigit("6") })
                        CalculatorButton(label: "-", action: { addOperation("-") })
                    }
                    HStack {
                        CalculatorButton(label: "1", action: { addDigit("1") })
                        CalculatorButton(label: "2", action: { addDigit("2") })
                        CalculatorButton(label: "3", action: { addDigit("3") })
                        CalculatorButton(label: "+", action: { addOperation("+") })
                    }
                    HStack {
                        CalculatorButton(label: "AC", action: clearDisplay)
                        CalculatorButton(label: "0", action: { addDigit("0") })
                        CalculatorButton(label: ".", action: { addDigit(".") })
                        CalculatorButton(label: "=", action: calculateResult)
                    }
                }
            }
        }
        .padding()
        .font(.largeTitle)
    }
    
    private func addDigit(_ digit: String) {
        if display == "0" || display == "Error" {
            display = digit
        } else {
            display += digit
        }
    }
    
    private func addOperation(_ operation: String) {
        if let lastChar = display.last, "+-*/".contains(lastChar) {
            display.removeLast()
            display += "\(operation)"
        } else {
            display += " \(operation) "
        }
        lastOperator = operation
    }
    
    private func calculateResult() {
        let expression = NSExpression(format: display.replacingOccurrences(of: " ", with: ""))
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            let resultString = result.stringValue
            history.append("\(display) = \(resultString)")
            display = resultString
        } else {
            display = "Error"
        }
        lastOperator = nil
    }
    
    private func clearDisplay() {
        display = "0"
        lastOperator = nil
    }
    
    private func calculatePercentage() {
        var components = display.split(separator: " ").map { String($0) }
        if var lastComponent = components.last, let value = Double(lastComponent) {
            lastComponent = String(value / 100)
            components[components.count - 1] = lastComponent
            display = components.joined(separator: " ")
        } else {
            display = "Error"
        }
    }
    
    private func memoryAdd() {
        if let value = Double(display) {
            memory += value
            isMemoryStored = true  // Set state to true when something is stored in memory
        } else {
            display = "Error"
        }
    }
    
    private func memorySubtract() {
        if let value = Double(display) {
            memory -= value
            isMemoryStored = true  // Set state to true when something is stored in memory
        } else {
            display = "Error"
        }
    }
    
    private func memoryClear() {
        memory = 0.0
        isMemoryStored = false  // Set state to false when memory is cleared
    }
    
    private func memoryRecall() {
        if lastOperator != nil {
            display += " \(memory)"
        } else {
            display = String(memory)
        }
    }
    
    private func toggleSign() {
        var components = display.split(separator: " ").map { String($0) }
        if var lastComponent = components.last, let value = Double(lastComponent) {
            lastComponent = String(-value)
            components[components.count - 1] = lastComponent
            display = components.joined(separator: " ")
        } else {
            display = "Error"
        }
    }
    
    private func backspace() {
        if display != "0" {
            display.removeLast()
            if display.isEmpty {
                display = "0"
            }
        }
    }
}

struct CalculatorButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .frame(width: 80, height: 80)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(40)
        }
    }
}

struct MemoryButton: View {
    let label: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(label: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.label = label
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .frame(width: 80, height: 40)
                .background(isEnabled ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(20)
        }
        .disabled(!isEnabled)
    }
}
