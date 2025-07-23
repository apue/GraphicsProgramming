#ifndef ExampleBase_hpp
#define ExampleBase_hpp

#include <string>
#include <memory>
#include <functional>
#include <unordered_map>
#include <vector>
#include <iostream>

// 示例信息结构体
struct ExampleInfo {
    std::string className;
    std::string id;
    std::string title;
    std::string chapter;
    std::string description;
    int order;
    std::function<std::unique_ptr<class ExampleBase>()> creator;
};

// 示例基类
class ExampleBase {
public:
    virtual ~ExampleBase() = default;
    
    // 核心生命周期方法
    virtual void initialize() = 0;
    virtual void display() = 0;
    virtual void cleanup() = 0;
    virtual void onResize(int width, int height) {}
    virtual void update(float deltaTime) {}
    virtual std::string getName() const = 0;
};

// 示例注册表
class ExampleRegistry {
public:
    static ExampleRegistry& getInstance() {
        static ExampleRegistry instance;
        return instance;
    }
    
    void registerExample(const std::string& className, 
                        const std::string& id,
                        const std::string& title,
                        const std::string& chapter,
                        const std::string& description,
                        int order,
                        std::function<std::unique_ptr<ExampleBase>()> creator) {
        ExampleInfo info;
        info.className = className;
        info.id = id;
        info.title = title;
        info.chapter = chapter;
        info.description = description;
        info.order = order;
        info.creator = creator;
        
        examples_[id] = info;
        std::cout << "Registered example: " << title << " (" << id << ")" << std::endl;
    }
    
    std::unique_ptr<ExampleBase> createExample(const std::string& id) {
        auto it = examples_.find(id);
        if (it != examples_.end()) {
            return it->second.creator();
        }
        std::cout << "Warning: Example '" << id << "' not found in registry" << std::endl;
        return nullptr;
    }
    
    std::vector<ExampleInfo> getAllExamples() const {
        std::vector<ExampleInfo> result;
        for (const auto& pair : examples_) {
            result.push_back(pair.second);
        }
        
        // 按章节和顺序排序
        std::sort(result.begin(), result.end(), 
            [](const ExampleInfo& a, const ExampleInfo& b) {
                if (a.chapter != b.chapter) {
                    return a.chapter < b.chapter;
                }
                return a.order < b.order;
            });
        
        return result;
    }
    
    bool hasExample(const std::string& id) const {
        return examples_.find(id) != examples_.end();
    }

private:
    std::unordered_map<std::string, ExampleInfo> examples_;
};

// 新的自动注册宏
#define AUTO_EXAMPLE(ClassName, ID, Title, Chapter, Description, Order) \
    namespace { \
        struct ClassName##AutoRegister { \
            ClassName##AutoRegister() { \
                ExampleRegistry::getInstance().registerExample( \
                    #ClassName, ID, Title, Chapter, Description, Order, \
                    []() { return std::make_unique<ClassName>(); } \
                ); \
            } \
        }; \
        static ClassName##AutoRegister ClassName##auto_register; \
    }

#endif /* ExampleBase_hpp */