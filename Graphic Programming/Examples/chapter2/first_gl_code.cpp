//
//  first_gl_code.cpp
//  Graphic Programming
//
//  Created by Yang Tian on 2025/7/22.
//

#include "ExampleBase.hpp"
#include <OpenGL/gl3.h>
#include <iostream>
#include <string>
#include <cmath>

class FirstGlExample : public ExampleBase {
public:
    void initialize() override {
        std::cout << "Initializing FirstGlExample" << std::endl;
    }
    
    void display() override {
        glClearColor(1.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);
    }
    
    void cleanup() override {
        
    }
    
    void onResize(int w, int h) override {
        
    }
    
    std::string getName() const override {
        return "FirstGlExample";
    }
};

REGISTER_EXAMPLE(FirstGlExample);

