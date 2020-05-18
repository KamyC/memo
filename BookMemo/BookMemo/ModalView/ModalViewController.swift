
import UIKit

class ModalViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //button
        button.addTarget(self, action: #selector(pushOK), for: .touchUpInside)
        //textField
        textField.addTarget(self, action: #selector(judgeButtonEnable), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        label.font = UIFont(name: "03SmartFontUI", size: label.frame.size.height * 0.65)
        button.titleLabel?.font = UIFont(name: "03SmartFontUI", size: 17)
        textField.font = UIFont(name: "03SmartFontUI", size: textField.frame.size.height * 0.4)
        //TextField
        let buttomLine = CALayer()
        buttomLine.borderWidth = CGFloat(2.0)
        buttomLine.borderColor = (UIColor(red: 24/255, green: 95/255, blue: 48/255, alpha: 1)).cgColor
        buttomLine.frame = CGRect(x: 0, y: textField.frame.size.height * 0.75, width: textField.frame.size.width, height: 1)
        textField.layer.addSublayer(buttomLine)
        //textField
        textField.text = ""
        //button
        button.isEnabled = false
    }

    //button
    @objc func pushOK() {
        //
        self.dismiss(animated: true, completion: nil)
        //view
        let navigationController = self.presentingViewController as! UINavigationController
        let bookListViewController = navigationController.topViewController as! BookListViewController
        bookListViewController.newBook = self.textField.text!.trimmingCharacters(in: .whitespaces)
        //add new book
        bookListViewController.addBook()
    }
    
    //textField
    @objc func judgeButtonEnable() {
        if textField.text!.trimmingCharacters(in: .whitespaces) == "" {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    //textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.endEditing(true)
    }


}
