//
//  ViewController.swift
//  RxTableTest
//
//  Created by Andrew Dolce on 12/14/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Intrepid

struct ItemViewModel {
    let identifier: String
    let text: String
    let textColor: UIColor
    let backgroundColor: UIColor
}

extension ItemViewModel: IdentifiableType {
    typealias Identity = String

    var identity: String {
        return identifier
    }
}

extension ItemViewModel: Equatable {
    static func == (lhs: ItemViewModel, rhs: ItemViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}

struct MySection: AnimatableSectionModelType {
    typealias Item = ItemViewModel

    var header: String {
        return ""
    }

    var items: [Item]

    var identity: String {
        return "TheOnlySection"
    }

    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension UITableViewCell {
    func configureWithViewModel(_ viewModel: ItemViewModel) {
        textLabel?.text = viewModel.text
        textLabel?.textColor = viewModel.textColor
        backgroundColor = viewModel.backgroundColor
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var items = Variable([ItemViewModel]())
    var dataSource: RxTableViewSectionedAnimatedDataSource<MySection>? = nil

    let cellIdentifier = "CellIdentifier"
    let bag = DisposeBag()

    func loadItems() {
        items.value = [
            ItemViewModel(identifier: "item0", text: "Hello", textColor: .black, backgroundColor: .white),
            ItemViewModel(identifier: "item1", text: "Is there anybody in there?", textColor: .white, backgroundColor: .black),
            ItemViewModel(identifier: "item2", text: "Just smile if you can hear me.", textColor: .white, backgroundColor: .blue),
        ]
    }

    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        let dataSource: RxTableViewSectionedAnimatedDataSource<MySection> = RxTableViewSectionedAnimatedDataSource<MySection>()

//        let label = UILabel()
//        label.rx.text.asObserver()
//
//        let ext = tableView.rx

        items.asObservable().bindTo(tableView.rx.items(dataSource: dataSource)) >>> bag
//            .bindTo(ext.items(dataSource: dataSource))
//            .addDisposableTo(bag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

