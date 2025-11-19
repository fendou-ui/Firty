import UIKit
import SVProgressHUD

class Lady_TabDailyTasksViewController: UIViewController {
    
    private var lady_titleView: UIView!
    private var lady_titleLabel: UILabel!
    private var lady_progressView: UIView!
    private var lady_progressLabel: UILabel!
    private var lady_progressBar: UIProgressView!
    private var lady_tableView: UITableView!
    private var lady_addTaskButton: UIButton!
    
    private var lady_dailyTasks = [[String: Any]]()
    private var lady_completedTasks = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lady_loadTasks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_createViews()
        lady_setupUI()
        lady_setupTableView()
        lady_loadTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 标题栏设置为透明，显示背景图片
        lady_titleView.backgroundColor = .clear
    }
    
    private func lady_createViews() {
        view.backgroundColor = UIColor.systemBackground
        
        // 添加背景图片
        let backgroundImageView = UIImageView(image: UIImage(named: "lady-BJ"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 创建标题视图
        lady_titleView = UIView()
        lady_titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lady_titleView)
        
        // 创建标题标签
        lady_titleLabel = UILabel()
        lady_titleLabel.text = "Daily Tasks"
        lady_titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        lady_titleLabel.textColor = .white
        lady_titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lady_titleView.addSubview(lady_titleLabel)
        
        // 创建进度视图
        lady_progressView = UIView()
        lady_progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lady_progressView)
        
        // 创建进度标签
        lady_progressLabel = UILabel()
        lady_progressLabel.text = "0/0 tasks completed"
        lady_progressLabel.font = UIFont.systemFont(ofSize: 16)
        lady_progressLabel.textColor = .label
        lady_progressLabel.translatesAutoresizingMaskIntoConstraints = false
        lady_progressView.addSubview(lady_progressLabel)
        
        // 创建进度条
        lady_progressBar = UIProgressView(progressViewStyle: .default)
        lady_progressBar.translatesAutoresizingMaskIntoConstraints = false
        lady_progressView.addSubview(lady_progressBar)
        
        // 创建表格视图
        lady_tableView = UITableView()
        lady_tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lady_tableView)
        
        // 创建添加按钮
        lady_addTaskButton = UIButton(type: .system)
        lady_addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        lady_addTaskButton.addTarget(self, action: #selector(lady_addTaskButtonTapped), for: .touchUpInside)
        view.addSubview(lady_addTaskButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 标题视图约束
            lady_titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lady_titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lady_titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lady_titleView.heightAnchor.constraint(equalToConstant: 80),
            
            // 标题标签约束
            lady_titleLabel.leadingAnchor.constraint(equalTo: lady_titleView.leadingAnchor, constant: 20),
            lady_titleLabel.centerYAnchor.constraint(equalTo: lady_titleView.centerYAnchor),
            
            // 进度视图约束
            lady_progressView.topAnchor.constraint(equalTo: lady_titleView.bottomAnchor, constant: 20),
            lady_progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lady_progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lady_progressView.heightAnchor.constraint(equalToConstant: 80),
            
            // 进度标签约束
            lady_progressLabel.topAnchor.constraint(equalTo: lady_progressView.topAnchor, constant: 15),
            lady_progressLabel.leadingAnchor.constraint(equalTo: lady_progressView.leadingAnchor, constant: 15),
            lady_progressLabel.trailingAnchor.constraint(equalTo: lady_progressView.trailingAnchor, constant: -15),
            
            // 进度条约束
            lady_progressBar.topAnchor.constraint(equalTo: lady_progressLabel.bottomAnchor, constant: 10),
            lady_progressBar.leadingAnchor.constraint(equalTo: lady_progressView.leadingAnchor, constant: 15),
            lady_progressBar.trailingAnchor.constraint(equalTo: lady_progressView.trailingAnchor, constant: -15),
            lady_progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            // 表格视图约束
            lady_tableView.topAnchor.constraint(equalTo: lady_progressView.bottomAnchor, constant: 20),
            lady_tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lady_tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lady_tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 添加按钮约束
            lady_addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lady_addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            lady_addTaskButton.widthAnchor.constraint(equalToConstant: 60),
            lady_addTaskButton.heightAnchor.constraint(equalToConstant: 60)
        ])
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
        
        lady_addTaskButton.layer.cornerRadius = 30
        lady_addTaskButton.backgroundColor = UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1)
        lady_addTaskButton.setTitle("+", for: .normal)
        lady_addTaskButton.setTitleColor(.white, for: .normal)
        lady_addTaskButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        lady_addTaskButton.layer.shadowColor = UIColor.black.cgColor
        lady_addTaskButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        lady_addTaskButton.layer.shadowRadius = 4
        lady_addTaskButton.layer.shadowOpacity = 0.3
    }
    
    private func lady_setupTableView() {
        lady_tableView.dataSource = self
        lady_tableView.delegate = self
        lady_tableView.backgroundColor = .clear
        lady_tableView.register(UITableViewCell.self, forCellReuseIdentifier: "task")
        lady_tableView.separatorStyle = .none
    }
    
    private func lady_loadTasks() {
        let today = lady_getTodayString()
        
        if let tasks = UserDefaults.standard.object(forKey: "lady_tasks_\(today)") as? [[String: Any]] {
            lady_dailyTasks = tasks
        } else {
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
    
    @objc func lady_addTaskButtonTapped() {
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

extension Lady_TabDailyTasksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lady_dailyTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "task")
        let task = lady_dailyTasks[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        // 配置 cell
        let title = task["title"] as? String ?? ""
        let description = task["description"] as? String ?? ""
        let isCompleted = task["completed"] as? Bool ?? false
        
        cell.textLabel?.text = isCompleted ? "✅ \(title)" : "⬜ \(title)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.detailTextLabel?.text = description
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.textColor = .systemGray
        cell.detailTextLabel?.numberOfLines = 2
        
        // 添加背景视图
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.systemGray6
        backgroundView.layer.cornerRadius = 12
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(backgroundView)
        cell.contentView.sendSubviewToBack(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
            backgroundView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
            backgroundView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
            backgroundView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5)
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lady_toggleTask(at: indexPath.row)
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
