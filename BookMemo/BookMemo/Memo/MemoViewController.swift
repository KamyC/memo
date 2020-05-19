

import UIKit

class MemoViewController: UIViewController, UINavigationControllerDelegate {

    //Outlet
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var textView : UITextView!
    //navigationBar
    var titleString = "No Title"
    var contentString = String()
    var memoNumber = Int()
    
    //if it is new memo
    var isNewMemo = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self

        textView.text = contentString
        textView.font = UIFont(name: "Misty Black", size: 16)
//        textView.font = UIFont(name: "03SmartFontUI", size: 16)

        
        navigationItem.largeTitleDisplayMode = .never
        
//        titleTextField.font = UIFont(name: "03SmartFontUI", size: 20)
        
        let buttomLine = CALayer()
        buttomLine.borderWidth = CGFloat(2.0)
        buttomLine.borderColor = (UIColor.white).cgColor
        buttomLine.frame = CGRect(x: 0, y: titleTextField.frame.size.height * 0.9,
                                  width: titleTextField.frame.size.width, height: 1)
        titleTextField.layer.addSublayer(buttomLine)
        titleTextField.textColor = .white
        
        if navigationItem.title != nil{
            titleString = navigationItem.title!
        }
        
        titleTextField.text = titleString
        
        //
        titleTextField.addTarget(self, action: #selector(presentTitle), for: .editingDidEnd)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let memoListViewController = viewController as? MemoListViewController {
            // returnView
            memoListViewController.newMemoTitle = self.titleString
            memoListViewController.newMemoContent = self.textView.text.trimmingCharacters(in: .newlines)
            memoListViewController.isNewMemoEmpty = self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            if isNewMemo {
                memoListViewController.addMemo()
            } else {
                memoListViewController.memoNumber = self.memoNumber
                memoListViewController.update()
            }

        }
    }
    
    @objc func presentTitle() {
        if titleTextField.text!.trimmingCharacters(in: .whitespaces) != "" {
            titleString = titleTextField.text!.trimmingCharacters(in: .whitespaces)
        } else {
            titleString = "No Title"
            titleTextField.text = titleString
        }
        navigationItem.title = titleString
    }

    //textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.endEditing(true)
        textView.endEditing(true)
    }


}
