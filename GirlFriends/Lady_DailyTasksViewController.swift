import UIKit
import SVProgressHUD

class Lady_DailyTasksViewController: UIViewController {
    
    @IBOutlet weak var lady_titleView: UIView!
    @IBOutlet weak var lady_progressView: UIView!
    @IBOutlet weak var lady_progressLabel: UILabel!
    @IBOutlet weak var lady_progressBar: UIProgressView!
    @IBOutlet weak var lady_tableView: UITableView!
    @IBOutlet weak var lady_addTaskButton: UIButton!
    
    private var lady_dailyTasks = [[String: Any]]()
    private var lady_completedTasks = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lady_loadTasks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_setupUI()
        lady_setupTableView()
        lady_loadTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lady_titleView.lady_colorGradient(lady_colors: [UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1), UIColor(red: 1, green: 0.8, blue: 1, alpha: 1)])
    }
    
    private func lady_setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        
        lady_progressView.layer.cornerRadius = 12
        lady_progressView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        lady_progressView.layer.shadowColor = UIColor.black.cgColor
        lady_progressView.layer.shadowOffset = CGSize(width: 0, height: 2)
        lady_progressView.layer.shadowRadius = 4
        lady_progressView.layer.shadowOpacity = 0.1
        
        lady_progressBar.progressTintColor = UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1)
        lady_progressBar.trackTintColor = UIColor.lightGray.withAlphaComponent(0.3)
        lady_progressBar.layer.cornerRadius = 4
        lady_progressBar.clipsToBounds = true
        
        lady_addTaskButton.layer.cornerRadius = 25
        lady_addTaskButton.backgroundColor = UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1)
        lady_addTaskButton.setTitle("+", for: .normal)
        lady_addTaskButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    private func lady_setupTableView() {
        lady_tableView.dataSource = self
        lady_tableView.delegate = self
        lady_tableView.backgroundColor = .clear
        lady_tableView.register(UINib(nibName: "Lady_TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "task")
        lady_tableView.separatorStyle = .none
    }
    
    private func lady_loadTasks() {
        let today = lady_getTodayString()
        
        if let tasks = UserDefaults.standard.object(forKey: "lady_tasks_\(today)") as? [[String: Any]] {
            lady_dailyTasks = tasks
        } else {
            // 创建默认任务
            lady_createDefaultTasks()
        }
        
        lady_updateProgress()
        lady_tableView.reloadData()
    }
    
    private func lady_createDefaultTasks() {
        lady_dailyTasks = [
            ["title": "Morning Chat", "description": "Have a conversation with your AI companion", "completed": false, "category": "social"],
            ["title": "Share Your Mood", "description": "Record how you're feeling today", "completed": false, "category": "wellness"],
            ["title": "Watch a Video", "description": "Enjoy some entertainment content", "completed": false, "category": "entertainment"],
            ["title": "Evening Reflection", "description": "Reflect on your day before sleep", "completed": false, "category": "wellness"]
        ]
        lady_saveTasks()
    }
    
    private func lady_saveTasks() {
        let today = lady_getTodayString()
        UserDefaults.standard.setValue(lady_dailyTasks, forKey: "lady_tasks_\(today)")
    }
    
    private func lady_updateProgress() {
        lady_completedTasks = lady_dailyTasks.filter { $0["completed"] as? Bool == true }.count
        let totalTasks = lady_dailyTasks.count
        
        let progress = totalTasks > 0 ? Float(lady_completedTasks) / Float(totalTasks) : 0.0
        lady_progressBar.setProgress(progress, animated: true)
        
        lady_progressLabel.text = "\(lady_completedTasks)/\(totalTasks) tasks completed"
        
        if lady_completedTasks == totalTasks && totalTasks > 0 {
            lady_showCompletionCelebration()
        }
    }
    
    private func lady_showCompletionCelebration() {
        let alert = UIAlertController(title: "🎉 Congratulations!", message: "You've completed all your daily tasks! Great job!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default))
        present(alert, animated: true)
    }
    
    private func lady_getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    @IBAction func lady_backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lady_addTaskButton(_ sender: Any) {
        lady_showAddTaskAlert()
    }
    
    private func lady_showAddTaskAlert() {
        let alert = UIAlertController(title: "Add New Task", message: "Create a custom task for today", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Task title"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Task description (optional)"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let titleField = alert.textFields?.first,
                  let title = titleField.text,
                  !title.isEmpty else {
                SVProgressHUD.showError(withStatus: "Please enter a task title")
                return
            }
            
            let description = alert.textFields?[1].text ?? ""
            self.lady_addCustomTask(title: title, description: description)
        })
        
        present(alert, animated: true)
    }
    
    private func lady_addCustomTask(title: String, description: String) {
        let newTask: [String: Any] = [
            "title": title,
            "description": description,
            "completed": false,
            "category": "custom"
        ]
        
        lady_dailyTasks.append(newTask)
        lady_saveTasks()
        lady_updateProgress()
        lady_tableView.reloadData()
        
        SVProgressHUD.showSuccess(withStatus: "Task added!")
    }
    
    private func lady_toggleTask(at index: Int) {
        var task = lady_dailyTasks[index]
        let isCompleted = task["completed"] as? Bool ?? false
        task["completed"] = !isCompleted
        lady_dailyTasks[index] = task
        
        lady_saveTasks()
        lady_updateProgress()
        lady_tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        
        if !isCompleted {
            SVProgressHUD.showSuccess(withStatus: "Task completed! 🎉")
        }
    }
}

extension Lady_DailyTasksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lady_dailyTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! Lady_TaskTableViewCell
        let task = lady_dailyTasks[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.lady_configureTask(with: task, index: indexPath.row)
        
        cell.lady_taskToggleCallback = { [weak self] index in
            self?.lady_toggleTask(at: index)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = lady_dailyTasks[indexPath.row]
            if task["category"] as? String == "custom" {
                lady_dailyTasks.remove(at: indexPath.row)
                lady_saveTasks()
                lady_updateProgress()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                SVProgressHUD.showInfo(withStatus: "Default tasks cannot be deleted")
            }
        }
    }
}
