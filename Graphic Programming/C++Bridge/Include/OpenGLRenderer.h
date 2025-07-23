#ifndef OpenGLRenderer_h
#define OpenGLRenderer_h

#ifdef __cplusplus
extern "C" {
#endif

#include <OpenGL/gl3.h>

// C interface for Swift bridging
typedef struct ExampleInstance ExampleInstance;

// 示例实例管理
ExampleInstance* createExampleById(const char* id);
void destroyExample(ExampleInstance* example);
void initializeExample(ExampleInstance* example);
void renderExample(ExampleInstance* example);
void resizeExample(ExampleInstance* example, int width, int height);

// 示例信息结构体
struct CExampleInfo {
    const char* id;
    const char* title;
    const char* chapter;
    const char* description;
    int order;
};

// 示例信息获取
int cppGetExampleCount(void);
void cppGetExampleInfo(int index, struct CExampleInfo* info);

// 工具函数
unsigned int loadShader(const char* vertexSource, const char* fragmentSource);
void useShader(unsigned int shaderProgram);
void clearScreen(float r, float g, float b, float a);

#ifdef __cplusplus
}
#endif

#endif /* OpenGLRenderer_h */