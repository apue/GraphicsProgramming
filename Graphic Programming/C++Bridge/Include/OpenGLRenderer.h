#ifndef OpenGLRenderer_h
#define OpenGLRenderer_h

#ifdef __cplusplus
extern "C" {
#endif

#include <OpenGL/gl3.h>

// C interface for Swift bridging
typedef struct OpenGLRenderer OpenGLRenderer;

// Renderer lifecycle
OpenGLRenderer* createRenderer(void);
void destroyRenderer(OpenGLRenderer* renderer);

// Rendering functions
void initializeRenderer(OpenGLRenderer* renderer);
void renderFrame(OpenGLRenderer* renderer);
void resizeViewport(OpenGLRenderer* renderer, int width, int height);

// Shader management
unsigned int loadShader(const char* vertexSource, const char* fragmentSource);
void useShader(unsigned int shaderProgram);

// Drawing utilities
void clearScreen(float r, float g, float b, float a);
void drawTriangle(float vertices[9]);
void drawQuad(float vertices[12]);

#ifdef __cplusplus
}
#endif

#endif /* OpenGLRenderer_h */