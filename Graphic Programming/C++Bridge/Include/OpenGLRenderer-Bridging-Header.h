//
//  OpenGLRenderer-Bridging-Header.h
//  Graphic Programming
//
//  Bridging header for Swift to C++ integration
//

#ifndef OpenGLRenderer_Bridging_Header_h
#define OpenGLRenderer_Bridging_Header_h

#include "OpenGLRenderer.h"

// C function declarations for Swift
#ifdef __cplusplus
extern "C" {
#endif

// Example management functions
typedef struct ExampleInstance ExampleInstance;
ExampleInstance* createExampleByClassName(const char* className);
void destroyExample(ExampleInstance* example);
void initializeExample(ExampleInstance* example);
void renderExample(ExampleInstance* example);
void resizeExample(ExampleInstance* example, int width, int height);

#ifdef __cplusplus
}
#endif

#endif /* OpenGLRenderer_Bridging_Header_h */