//
//  ViewController.swift
//  Calculator-iOS
//
//  Created by Tiago Santo on 10/30/19.
//  Copyright © 2019 TiagoSanto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SessionCommands {

    @IBOutlet weak var valueXTextField: UITextField!
    @IBOutlet weak var valueYTextField: UITextField!
    @IBOutlet weak var resultValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateAppContext()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateAppContext()
    }

    @IBAction func multiplyTapped(_ sender: Any) {
        let valueX = Int(valueXTextField.text?.removeNonNumerics() ?? "0") ?? 0
        let valueY = Int(valueYTextField.text?.removeNonNumerics() ?? "0") ?? 0

        let result = valueX * valueY

        resultValueLabel.text = String(result)
        updateAppContext(resultValueLabel.text)
        
        resignFirstResponder()
    }
    
    // MARK: - SessionCommands

    private func updateAppContext(_ result: String? = nil) {
        let multiply = Multiply(result: result)
        let data = getMultiply(multiply)
        let context = [PayloadKey.multiply: data] as [String: Any]

        updateAppContext(context)
    }
    
    private func getMultiply(_ multiply: Multiply) -> [String: Any] {
        return multiply.toDictionary()
    }
}

private extension String {
    func removeNonNumerics() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
    }
}

