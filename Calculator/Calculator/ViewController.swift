//
//  ViewController.swift
//  Calculator
//
//  Created by dondrake on 2/7/15.
//  Copyright (c) 2015 Dreaming Mind. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Top display bar showing the current input or last evaluation
    @IBOutlet weak var display: UILabel!

    // History display showing past inputs, operations and results
    @IBOutlet weak var paperTape: UILabel!

    var tapeDisplay: String {
        get {
            return paperTape.text!
        }
        set {
            paperTape.text = "\(displayValue)" + "\n" + paperTape.text!
//            paperTape.text = "\(displayValue)"
            println(paperTape.text!)
        }
    }


    var userIsTyping = false
    
    var inputIsInteger = true
    
    @IBAction func appendDigit(sender: UIButton) {
        let input = sender.currentTitle!
        switch input {
        case ("0"..."9"):
            appendDigit(input)
        case ".":
            if inputIsInteger {
                inputIsInteger = false
                appendDigit(".")
            }
        case "π":
            if userIsTyping {
                enter()
            }
            appendDigit("\(M_PI)")
            enter()
        default: break
        }
        
    }
    
    func appendDigit(value: String) {
        if userIsTyping {
            display.text = display.text! + value
        } else {
            display.text = value
            userIsTyping = true
        }
        println("digit = \(value)")
    }

    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsTyping {
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default : break
        }
        
    }
    
    func performOperation(operation: (Double, Double)->Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double)->Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsTyping = false
        inputIsInteger = true
        operandStack.append(displayValue)
        tapeDisplay = "\(operandStack.last!)"
        println("\(operandStack)")
    }
    
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsTyping = false
            inputIsInteger = true
        }
    }
}

