//
//  ViewController.swift
//  MapViewUIKit
//
//  Created by Lalith  on 20/04/20.
//  Copyright © 2020 Lalith . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var intermediateTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 20
    }

    @IBAction func continueButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "MapSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sourceTextField.text != nil && destinationTextField.text != nil{
            let destination = segue.destination as! MapViewController
            destination.sourecCity = sourceTextField.text!
            destination.destinationCity = destinationTextField.text!
            destination.intermediateCity = intermediateTextField.text
        }
        else{
            print("fill in all fields")
        }
        
    }

}

