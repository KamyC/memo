

import UIKit
import RealmSwift

class MemoListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{

    //Outlet
    @IBOutlet var table : UITableView!
    @IBOutlet var addMemoButton : UIButton!
    @IBOutlet var searchBar : UISearchBar!
    
    //navigationBar title
    var titleString = String()
    //
    var newMemoTitle = String()
    var newMemoContent = String()
    //
    var memoTitle = String()
    var memoContent = String()
    var memoNumber = Int()
    //
    var bookNumber = Int()
    //Memo
    var isNewMemoEmpty = Bool()
    //
    var searchData = [(String,Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate dataSource
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        //UI
        table.tableFooterView = UIView()
        
        navigationItem.largeTitleDisplayMode = .never
        
        addMemoButton.layer.cornerRadius = 30
        addMemoButton.titleLabel?.font = UIFont(name: "03SmartFontUI", size: 40)
        
        searchBar.backgroundImage = UIImage()
        navigationController?.navigationBar.shadowImage = UIImage()

        //cell
        table.register(UINib(nibName: "BookListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        reset()
    }
    
    @objc func returnView() {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.delete(index: searchData[indexPath.row].1)
        searchData.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
    }
    
    //cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let memo = realm.objects(Book.self)[bookNumber].memos[searchData[indexPath.row].1]
        memoTitle = memo.title
        memoContent = memo.content
        memoNumber = searchData[indexPath.row].1
        performSegue(withIdentifier: "toMemoDetail", sender: nil)
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func addMemo() {
        if !isNewMemoEmpty {
            let memo = Memo()
            memo.title = newMemoTitle
            memo.content = newMemoContent
            do {
                let realm = try Realm()
                let book = realm.objects(Book.self)[bookNumber]
                try realm.write {
                    book.memos.append(memo)
                }
            } catch {
                
            }
            reset()
            table.reloadData()
        }
    }
    
    func update() {
        if isNewMemoEmpty {
            self.delete(index: memoNumber)
            table.reloadData()
        } else {
            do {
                let realm = try! Realm()
                let book = realm.objects(Book.self)[bookNumber]
                try realm.write {
                    book.memos[memoNumber].title = newMemoTitle
                    book.memos[memoNumber].content = newMemoContent
                }
            } catch {
                
            }
            reset()
            table.reloadData()
        }
    }

    func delete(index: Int) {
        do {
            let realm = try! Realm()
            let book = realm.objects(Book.self)[bookNumber]
            try realm.write {
                book.memos.remove(at: index)
            }
        } catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let memoViewController = segue.destination as! MemoViewController
        if segue.identifier == "toMemoDetail" {
            memoViewController.navigationItem.title = self.memoTitle
            memoViewController.contentString = self.memoContent
            memoViewController.memoNumber = self.memoNumber
            memoViewController.isNewMemo = false
        } else {
            memoViewController.contentString = ""
            memoViewController.isNewMemo = true
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
        let memos = realm.objects(Book.self)[bookNumber].memos
        searchData = [(String,Int)]()
        for i in 0..<memos.count {
            searchData.append((memos[i].title,i))
        }
    }


}
