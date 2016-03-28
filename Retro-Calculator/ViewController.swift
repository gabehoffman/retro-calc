//
//  ViewController.swift
//  Retro-Calculator
//
//  Created by Gabe at Work on 3/25/16.
//  Copyright © 2016 Gabe Hoffman. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Substract = "-"
        case Equals = "="
        case Empty = ""
    }
    
    struct Calculation {
        let leftValue: String
        let rightValue: String
        let operation: Operation
        let result: String
     
        init(left: String, right: String, op: Operation) {
            leftValue = left
            rightValue = right
            operation = op
            switch operation {
            case .Multiply:
                result = "\(Int(leftValue)! * Int(rightValue)!)"
            case .Divide:
                result = "\(Int(leftValue)! / Int(rightValue)!)"
            case .Add:
                print("add :left \(leftValue), right \(rightValue)")
                result = "\(Int(leftValue)! + Int(rightValue)!)"
            case .Substract:
                result = "\(Int(leftValue)! - Int(rightValue)!)"
            case .Equals:
                result = "Error"
            case .Empty:
                result = "Error"
            }
        }
        
        func inWords() -> String {
            return ("\(leftValue) \(operation) \(rightValue) = \(result)")
        }
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = .Empty
    var lastOperation: Operation = .Empty
    var actionHistory: [Calculation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        
        outputLbl.text = "0"
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func numberPressed(btn: UIButton) {
        playButtonSound()
        
        if lastOperation == .Equals {
            leftValStr = outputLbl.text!
            runningNumber = "\(btn.tag)"
        } else {
            runningNumber += "\(btn.tag)"
        }
        
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Substract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    func processOperation(op: Operation) {
        playButtonSound()
        
        if currentOperation != Operation.Empty {
            
            // If the user selects another operator without entering a number (i.e. equals
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                // Run
                let newCalculation = Calculation(left: leftValStr, right: rightValStr, op: currentOperation)
                let result = newCalculation.result
                actionHistory.append(newCalculation)
                print(newCalculation.inWords())
                lastOperation = currentOperation
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = op
            
        } else {
            // Only happens on initial operator press
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playButtonSound() {
        if btnSound.playing {
            btnSound.stop()
        }
    
        btnSound.play()
    }
}

