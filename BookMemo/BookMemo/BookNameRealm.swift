

import UIKit
import RealmSwift

class Memo: Object {
    @objc dynamic var title = ""
    @objc dynamic var content = ""
}

class Book: Object {
    @objc dynamic var bookName = ""
    let memos = List<Memo>()
}
