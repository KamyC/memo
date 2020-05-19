

import UIKit

class MemoViewController: UIViewController, UINavigationControllerDelegate {

    //Outlet
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var textView : UITextView!
    //navigationBar
    var titleString = "No Title"
    var content = String()
    var memoNumber = Int()
    
    //if it is new memo
    var isNewMemo = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background2.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        navigationController?.delegate = self

        textView.text = content
        navigationItem.largeTitleDisplayMode = .never
        
        let buttomLine = CALayer()
        buttomLine.borderWidth = CGFloat(2.0)
        buttomLine.borderColor = (UIColor.white).cgColor
        buttomLine.frame = CGRect(x: 0, y: titleTextField.frame.size.height * 0.9,
                                  width: titleTextField.frame.size.width, height: 1)
        titleTextField.layer.addSublayer(buttomLine)

        if navigationItem.title != nil{
            titleString = navigationItem.title!
        }
        
        titleTextField.text = titleString
        
        titleTextField.addTarget(self, action: #selector(presentTitle), for: .editingDidEnd)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let memoListViewController = viewController as? MemoListViewController {
            // returnView
            
            titleTextField.addTarget(self, action: #selector(presentTitle), for: .editingDidEnd)
            
            memoListViewController.newMemoTitle = self.titleString
        
            memoListViewController.newMemoContent = self.textView.text.trimmingCharacters(in: .newlines)
            if self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" && self.titleString.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                memoListViewController.isNewMemoEmpty = true
            }
            else{
                memoListViewController.isNewMemoEmpty = false
            }
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
        titleTextField.endEditing(false)
        textView.endEditing(true)
    }
    //unwind back to memo list
    @IBAction func doneEditing(_ sender: Any) {
        performSegue(withIdentifier: "unwindBack", sender: self)
    }
}
