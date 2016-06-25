//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Daniel Richardson on 21/06/2016.
//  Copyright © 2016 edu.utas.Daniel. All rights reserved.
//

import Foundation

class CalculatorBrain {

    // This is the running tally brought in from the ViewControler
    private var accumulator = 0.0

    // A binary operation requires two numbers (one on either side of the operation)
    // pending is used to store the value to the left side of the binary operation
    // and wait for the user to enter the left side of the binary operation operations
    // arugments. It's an optional because we don't want to use it unless the user wants
    // to use a binary operation.
    private var pending: PendingBinaryOperationInfo?

    // this is used to assign a value to pending. the firstOperand is the starting
    // value while waiting for more input from the user, the function then takes
    // the firstOperand and the new value entered by the user to actually do the
    // calculation and return the answer back to the display label.
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var fristOperand: Double
    }

    // This is how the ViewControler gets the calculated value done by the model
    // the variable has been set to only 'get' so that it can't be changed outside
    // the model.
    var result: Double {
        get {
            return accumulator
        }
    }

    // This is just a convenient way to set the accumlator
    func setOperand(operand: Double) {
        accumulator = operand
    }

    // This is a table of operations. The symbol is the operation
    // followed by what should be done for each operations.
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "x" : Operation.BinaryOperration({ $0 * $1 }),
        "÷" : Operation.BinaryOperration({ $0 / $1 }),
        "+" : Operation.BinaryOperration({ $0 + $1 }),
        "-" : Operation.BinaryOperration({ $0 - $1 }),
        "=" : Operation.Equels,
        "C" : Operation.Clear
    ]

    // This creates the conditions that expected in the dictionary
    // whenever those cases are found.
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperration((Double, Double) -> Double)
        case Equels
        case Clear
    }

    /**
     * @preformOperation: this is the logic that checks what operation was
     * selected and carries out those tasks on the number and operation to
     * be carried out.
     *
     * @Params: symbol is the mathmatical symbol entered by the user. for example,
     * + or - and what to do based on what symbol was pressed by the user.
     *
     * @Returns Void. It updates the accumulator which the ViewControler can access
     * directly in order to display the output of the calculation via the interface.
     *
     */
    func preformOperation(symbol: String) {
        if let operations = operations[symbol] {
            switch operations {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperration(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, fristOperand: accumulator)
            case .Equels:
                executePendingBinaryOperation()
            case .Clear:
                accumulator = 0
            }
        }
    }

    /**
     *  @executePendingBinaryOperation: this is called from the
     *  PendingBinaryOperationInfo struct when a user has entered the second value
     *  in which to compute the binary operation.
     *
     *  @Params: None.
     *
     *  @Returns: Void. Updates the accumlator's value based on the results of
     *  the binaryFunction().
     */
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.fristOperand, accumulator)
            pending = nil
        }
    }



    
}