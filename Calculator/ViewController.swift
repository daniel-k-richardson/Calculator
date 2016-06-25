//
//  ViewController.swift
//  Calculator
//
//  Created by Daniel Richardson on 21/06/2016.
//  Copyright © 2016 edu.utas.Daniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // The calculator's label for displaying the number and calculations.
    @IBOutlet private weak var display: UILabel!

    // Whether or not the user is currently typing in order to know if an append
    // is needed or a clear screen is required.
    private var userIsInTheMiddleOfTyping = false

    // This is a model object that represents the code for the calculator
    private var brain = CalculatorBrain()

    /**
     * @displayValue: this is a var that sets its value from a string to
     * a type of Double, but returns a type String. This is just convenient
     * because our label gives us a string that needs to be converted to a Double
     * so that our calculator model can use the value inside the label.
     *
     * @Input: String containing a numeric value.
     * @Output: Returns a numeric value that our model can use.
     */
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }


    /**
     *  @touchDigit: Handles the cases when users enter a numeric value via the
     *  number pad.
     *
     *  @Params: The name of the button that has been pressed.
     *  @Returns: Void.
     */
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!

        if (userIsInTheMiddleOfTyping) {
            let textCurrentlyInDisplay = display.text

            // deal with the case that the user enders a decimal symbol
            if (digit == "." && textCurrentlyInDisplay?.rangeOfString(".") == nil) {
                display.text = textCurrentlyInDisplay! + digit
            } else if digit != "." {
                display.text = textCurrentlyInDisplay! + digit
            }
        } else {
            display.text = digit.rangeOfString(".") != nil ? "0" + digit : digit
        }
        userIsInTheMiddleOfTyping  = true
    }

    /**
     * @proformOeration: This function handles all the mathematical functionality
     * of the mathematical operations. When a mathematical symbol is pressed on the
     * calculator's interface, that symbol and the current value of the display
     * is sent to the calculators model to preform the correct operation and return
     * the results of it back to the display label.
     *
     * @Params: sender is the button pressed, the title of that button (the symbol)
     * is sent to the .preformOperation and the correct subroutine is called.
     *
     * @Returns: void. However, the result from the operation is displayed to the
     * display label on the calculator.
     */
    @IBAction private func proformOperation(sender: UIButton) {

        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }

        if let mathmaticalSymbol = sender.currentTitle {
            brain.preformOperation(mathmaticalSymbol)
        }
        displayValue = brain.result
    }
}

