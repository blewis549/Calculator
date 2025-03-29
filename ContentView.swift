import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var memory: Double = 0.0
    @State private var history: [String] = []
    @State private var showHistory = false
    @State private var isMemoryStored = false  // State property to track if something is stored in memory
    @State private var lastOperator: String? = nil  // Track the last operator used
    @State private var justCalculated = false  // Track if a result was just calculated
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    showHistory.toggle()
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.gray.opacity(0))
                        .cornerRadius(10)
                }
                Spacer()
            }
            
            if showHistory {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("History...")
                        .font(.title)
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
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                        CalculatorButton(label: "AC", action: clearDisplay)
                        CalculatorButton(label: "+/-", action: toggleSign)
                        CalculatorButton(label: "%", action: calculatePercentage)
                        CalculatorButton(label: "÷", action: { addOperation("÷") }, backgroundColor: .orange)
                    }
                    HStack {
                        CalculatorButton(label: "7", action: { addDigit("7") })
                        CalculatorButton(label: "8", action: { addDigit("8") })
                        CalculatorButton(label: "9", action: { addDigit("9") })
                        CalculatorButton(label: "*", action: { addOperation("*") }, backgroundColor: .orange)
                    }
                    HStack {
                        CalculatorButton(label: "4", action: { addDigit("4") })
                        CalculatorButton(label: "5", action: { addDigit("5") })
                        CalculatorButton(label: "6", action: { addDigit("6") })
                        CalculatorButton(label: "-", action: { addOperation("-") }, backgroundColor: .orange)
                    }
                    HStack {
                        CalculatorButton(label: "1", action: { addDigit("1") })
                        CalculatorButton(label: "2", action: { addDigit("2") })
                        CalculatorButton(label: "3", action: { addDigit("3") })
                        CalculatorButton(label: "+", action: { addOperation("+") }, backgroundColor: .orange)
                    }
                    HStack {
                        CalculatorButton(label: "⌫", action: backspace)
                        CalculatorButton(label: "0", action: { addDigit("0") })
                        CalculatorButton(label: ".", action: { addDigit(".") })
                        CalculatorButton(label: "=", action: calculateResult, backgroundColor: .orange)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .font(.largeTitle)
    }
    
    private func addDigit(_ digit: String) {
        if justCalculated {
            display = digit
            justCalculated = false
        } else {
            if digit == "." {
                // Prevent adding another decimal point if one already exists in the current number
                if display.contains(".") {
                    return
                }
            }
            if display == "0" || display == "Error" {
                display = digit
            } else {
                display += digit
            }
        }
    }
    
    private func addOperation(_ operation: String) {
        if let lastChar = display.last, "+-*/÷".contains(lastChar) {
            display.removeLast()
            display += "\(operation)"
        } else {
            display += "\(operation)"
        }
        lastOperator = operation
        justCalculated = false
    }
    
    private func calculateResult() {
        // Check if the last character is an operator
        if let lastChar = display.last, "+-*/÷".contains(lastChar) {
            display = "Error"
            return
        }
        
        var formattedDisplay = display.replacingOccurrences(of: "÷", with: "/")
        formattedDisplay = formattedDisplay.replacingOccurrences(of: ",", with: "")
        let expressionString = formattedDisplay.replacingOccurrences(of: " ", with: "")
        
        // Check for division by zero
        if expressionString.contains("/0") {
            display = "Error"
            return
        }
        
        let expression = NSExpression(format: expressionString)
        if let result = expression.expressionValue(with: nil, context: nil) as? Double {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 10
            
            if let resultString = numberFormatter.string(from: NSNumber(value: result)) {
                history.append("\(display) = \(resultString)")
                display = resultString
            } else {
                display = "Error"
            }
        } else {
            display = "Error"
        }
        lastOperator = nil
        justCalculated = true
    }
    
    private func clearDisplay() {
        display = "0"
        lastOperator = nil
        justCalculated = false
    }
    
    private func calculatePercentage() {
        var components = display.split(separator: " ").map { String($0) }
        
        // Check if the last component is a number
        if let lastComponent = components.last, let value = Double(lastComponent) {
            // Replace the last component with its percentage value
            let percentageValue = value / 100
            components[components.count - 1] = String(percentageValue)
            display = components.joined(separator: " ")
        } else {
            display = "Error"
        }
        justCalculated = false
    }
    
    private func memoryAdd() {
        let formattedDisplay = display.replacingOccurrences(of: ",", with: "")
        if let value = Double(formattedDisplay) {
            memory += value
            isMemoryStored = true  // Set state to true when something is stored in memory
        } else {
            display = "Error"
        }
        justCalculated = false
    }
    
    private func memorySubtract() {
        let formattedDisplay = display.replacingOccurrences(of: ",", with: "")
        if let value = Double(formattedDisplay) {
            memory -= value
            isMemoryStored = true  // Set state to true when something is stored in memory
        } else {
            display = "Error"
        }
        justCalculated = false
    }
    
    private func memoryClear() {
        memory = 0.0
        isMemoryStored = false  // Set state to false when memory is cleared
        justCalculated = false
    }
    
    private func memoryRecall() {
        if lastOperator != nil {
            display += " \(memory)"
        } else {
            display = String(memory)
        }
        justCalculated = false
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
        justCalculated = false
    }
    
    private func backspace() {
        if display != "0" {
            display.removeLast()
            if display.isEmpty {
                display = "0"
            }
        }
        justCalculated = false
    }
}

struct CalculatorButton: View {
    let label: String
    let action: () -> Void
    var backgroundColor: Color = .blue
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .frame(width: 80, height: 80)
                .background(backgroundColor)
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
                .frame(width: 80, height: 30)
                .background(isEnabled ? Color.blue.opacity(0.5) : Color.gray)
                .font(.body)
                .foregroundColor(.white)
                .cornerRadius(20)
        }
        .disabled(!isEnabled)
    }
}
