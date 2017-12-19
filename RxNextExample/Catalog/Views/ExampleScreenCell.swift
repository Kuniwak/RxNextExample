import UIKit



class ExampleScreenCell: UITableViewCell {
    static let reuseIdentifier = "ScreenCell"


    var screen: ExampleScreen? {
        didSet {
            self.textLabel?.text = screen?.title
        }
    }


    static func register(to tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: self.reuseIdentifier)
    }


    static func dequeue(from tableView: UITableView, screen: ExampleScreen) -> ExampleScreenCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as? ExampleScreenCell else {
            fatalError("Please register \(self.reuseIdentifier)")
        }

        cell.screen = screen
        return cell
    }
}