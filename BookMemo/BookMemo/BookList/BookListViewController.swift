

import UIKit
import PopupDialog
import RealmSwift

class BookListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    //Outlet
    @IBOutlet var label : UILabel!
    @IBOutlet var table : UITableView!
    @IBOutlet var addCellButton : UIButton!
    @IBOutlet var searchBar : UISearchBar!
    
    @IBAction func DoneButton(_ sender: Any) {
        self.view.endEditing(false)
    }
    //
    var newBook = String()
    //
    var titleText = String()
    //ModalView
    let modalView = ModalViewController(nibName: "ModalViewController", bundle: nil) as UIViewController
    //
    var bookNumber = Int()
    //
    var searchData = [(String,Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegateとdataSource
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        
        //UI
        addCellButton.layer.cornerRadius = 30
//        addCellButton.titleLabel?.font = UIFont(name: "03SmartFontUI", size: 40)
        table.tableFooterView = UIView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "03SmartFontUI", size: 40) as Any,
             NSAttributedString.Key.foregroundColor: UIColor.white]

                
        searchBar.backgroundImage = UIImage()
        navigationController?.navigationBar.shadowImage = UIImage()
                
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        //cell
        table.register(UINib(nibName: "BookListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        //ButtonAction
        addCellButton.addTarget(self, action: #selector(presentModal), for: UIControl.Event.touchUpInside)
        
        reset()
    }
    
    //
    @objc func presentModal() {
        //background
        let overlayAppearance = PopupDialogOverlayView.appearance()
        overlayAppearance.color           = .white
        overlayAppearance.blurRadius      = 5
        overlayAppearance.blurEnabled     = true
        overlayAppearance.liveBlurEnabled = false
        overlayAppearance.opacity         = 0.2
        //PopUp
        let popup = PopupDialog(viewController: modalView, transitionStyle: .zoomIn, preferredWidth: 220) as UIViewController
        //PopUp
        present(popup, animated: true, completion: {() -> Void in
            
        })
    }

    //bookNameArray
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = table.dequeueReusableCell(withIdentifier: "CustomCell") as! BookListTableViewCell
        customCell.bookNameLabel.text = searchData[indexPath.row].0
        return customCell
    }
    
    //cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    //cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleText = searchData[indexPath.row].0
        bookNumber = searchData[indexPath.row].1
        performSegue(withIdentifier: "toMemoList", sender: nil)
        table.deselectRow(at: indexPath, animated: true)
    }
    
    //cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.delete(index: searchData[indexPath.row].1)
        searchData.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemoList" {
            let memoListViewController = segue.destination as! MemoListViewController
            memoListViewController.navigationItem.title = titleText
            memoListViewController.bookNumber = self.bookNumber
        }
    }
    
    func addBook() {
        let book = Book()
        book.bookName = newBook
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(book)
            }
        } catch {
            
        }
//        table.reloadData()
        self.search(searchBar)
    }
    
    func delete(index: Int) {
        do {
            let realm = try! Realm()
            let books = realm.objects(Book.self)
            try realm.write {
                realm.delete(books[index])
            }
        } catch {
            
        }
    }
    
    //searchBar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
        search(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar)
    }
    
    func search(_ searchBar: UISearchBar) {
        reset()
        if searchBar.text! != "" {
            searchBar.endEditing(true)
            let dataArray = searchData
            searchData = dataArray.filter{
                $0.0.lowercased().contains(searchBar.text!.lowercased())
            }
            table.reloadData()
        } else {
            table.reloadData()
        }
    }
    
    func reset() {
        let realm = try! Realm()
        let books = realm.objects(Book.self)
        searchData = [(String,Int)]()
        for i in 0..<books.count {
            searchData.append((books[i].bookName,i))
        }
    }


}
