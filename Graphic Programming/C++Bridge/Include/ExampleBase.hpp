#ifndef ExampleBase_hpp
#define ExampleBase_hpp

#include <string>
#include <memory>
#include <functional>
#include <unordered_map>
#include <iostream>

class ExampleBase {
public:
    virtual ~ExampleBase() = default;
    
    // Core lifecycle methods
    virtual void initialize() = 0;
    virtual void display() = 0;
    virtual void cleanup() = 0;
    virtual void onResize(int width, int height) {}
    
    // Optional methods
    virtual void update(float deltaTime) {}
    virtual std::string getName() const = 0;
};

// Example Registry for automatic registration
class ExampleRegistry {
public:
    using CreateFunc = std::function<std::unique_ptr<ExampleBase>()>;
    
    static ExampleRegistry& getInstance() {
        static ExampleRegistry instance;
        return instance;
    }
    
    void registerExample(const std::string& className, CreateFunc creator) {
        creators_[className] = creator;
        std::cout << "Registered example: " << className << std::endl;
    }
    
    std::unique_ptr<ExampleBase> createExample(const std::string& className) {
        auto it = creators_.find(className);
        if (it != creators_.end()) {
            return it->second();
        }
        std::cout << "Warning: Example '" << className << "' not found in registry" << std::endl;
        return nullptr;
    }
    
    std::vector<std::string> getRegisteredExamples() const {
        std::vector<std::string> names;
        for (const auto& pair : creators_) {
            names.push_back(pair.first);
        }
        return names;
    }
    
private:
    std::unordered_map<std::string, CreateFunc> creators_;
};

// Helper macro for easy registration
#define REGISTER_EXAMPLE(ClassName) \
    namespace { \
        bool ClassName##_registered = []() { \
            ExampleRegistry::getInstance().registerExample(#ClassName, []() { \
                return std::make_unique<ClassName>(); \
            }); \
            return true; \
        }(); \
    }

#endif /* ExampleBase_hpp */