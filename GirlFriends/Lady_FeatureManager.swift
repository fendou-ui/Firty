import UIKit
import SVProgressHUD

class Lady_FeatureManager {
    
    static let shared = Lady_FeatureManager()
    
    private init() {}
    
    // MARK: - 收藏功能管理
    
    func lady_addToFavorites(message: String, character: String, image: String) -> Bool {
        let favoriteItem: [String: String] = [
            "lady_message": message,
            "lady_character": character,
            "lady_image": image,
            "lady_time": lady_getCurrentTimeString(),
            "lady_date": lady_getCurrentDateString()
        ]
        
        var favorites = UserDefaults.standard.object(forKey: "lady_favorites") as? [[String: String]] ?? []
        
        // 检查重复
        let isDuplicate = favorites.contains { favorite in
            return favorite["lady_message"] == message && favorite["lady_character"] == character
        }
        
        if !isDuplicate {
            favorites.insert(favoriteItem, at: 0)
            
            // 限制数量
            if favorites.count > 100 {
                favorites = Array(favorites.prefix(100))
            }
            
            UserDefaults.standard.setValue(favorites, forKey: "lady_favorites")
            return true
        }
        return false
    }
    
    func lady_getFavorites() -> [[String: String]] {
        return UserDefaults.standard.object(forKey: "lady_favorites") as? [[String: String]] ?? []
    }
    
    func lady_removeFavorite(at index: Int) {
        var favorites = lady_getFavorites()
        guard index < favorites.count else { return }
        
        favorites.remove(at: index)
        UserDefaults.standard.setValue(favorites, forKey: "lady_favorites")
    }
    
    // MARK: - 心情追踪功能管理
    
    func lady_saveMood(_ mood: [String: String]) {
        let today = lady_getTodayString()
        var moodWithDate = mood
        moodWithDate["date"] = today
        moodWithDate["time"] = lady_getCurrentTimeString()
        
        // 保存今日心情
        UserDefaults.standard.setValue(moodWithDate, forKey: "lady_mood_\(today)")
        
        // 更新历史记录
        var history = lady_getMoodHistory()
        history.removeAll { $0["date"] == today }
        history.insert(moodWithDate, at: 0)
        
        // 保留30天记录
        if history.count > 30 {
            history = Array(history.prefix(30))
        }
        
        UserDefaults.standard.setValue(history, forKey: "lady_mood_history")
    }
    
    func lady_getTodayMood() -> [String: String]? {
        let today = lady_getTodayString()
        return UserDefaults.standard.object(forKey: "lady_mood_\(today)") as? [String: String]
    }
    
    func lady_getMoodHistory() -> [[String: String]] {
        return UserDefaults.standard.object(forKey: "lady_mood_history") as? [[String: String]] ?? []
    }
    
    // MARK: - 每日任务功能管理
    
    func lady_getTodayTasks() -> [[String: Any]] {
        let today = lady_getTodayString()
        return UserDefaults.standard.object(forKey: "lady_tasks_\(today)") as? [[String: Any]] ?? []
    }
    
    func lady_saveTodayTasks(_ tasks: [[String: Any]]) {
        let today = lady_getTodayString()
        UserDefaults.standard.setValue(tasks, forKey: "lady_tasks_\(today)")
    }
    
    func lady_getTaskProgress() -> (completed: Int, total: Int) {
        let tasks = lady_getTodayTasks()
        let completed = tasks.filter { $0["completed"] as? Bool == true }.count
        return (completed, tasks.count)
    }
    
    func lady_createDefaultTasks() -> [[String: Any]] {
        return [
            ["title": "Morning Chat", "description": "Have a conversation with your AI companion", "completed": false, "category": "social"],
            ["title": "Share Your Mood", "description": "Record how you're feeling today", "completed": false, "category": "wellness"],
            ["title": "Watch a Video", "description": "Enjoy some entertainment content", "completed": false, "category": "entertainment"],
            ["title": "Evening Reflection", "description": "Reflect on your day before sleep", "completed": false, "category": "wellness"]
        ]
    }
    
    // MARK: - 通用工具方法
    
    private func lady_getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    private func lady_getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func lady_getTodayString() -> String {
        return lady_getCurrentDateString()
    }
    
    // MARK: - 数据统计功能
    
    func lady_getWeeklyMoodStats() -> [String: Int] {
        let history = lady_getMoodHistory()
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        var stats: [String: Int] = [:]
        
        for mood in history {
            guard let dateString = mood["date"],
                  let date = DateFormatter().date(from: dateString),
                  date >= weekAgo,
                  let moodName = mood["name"] else { continue }
            
            stats[moodName, default: 0] += 1
        }
        
        return stats
    }
    
    func lady_getTaskCompletionRate() -> Double {
        let progress = lady_getTaskProgress()
        guard progress.total > 0 else { return 0.0 }
        return Double(progress.completed) / Double(progress.total)
    }
    
    // MARK: - 通知和提醒功能
    
    func lady_shouldShowMoodReminder() -> Bool {
        return lady_getTodayMood() == nil && Calendar.current.component(.hour, from: Date()) >= 18
    }
    
    func lady_shouldShowTaskReminder() -> Bool {
        let progress = lady_getTaskProgress()
        return progress.completed < progress.total && Calendar.current.component(.hour, from: Date()) >= 20
    }
}
