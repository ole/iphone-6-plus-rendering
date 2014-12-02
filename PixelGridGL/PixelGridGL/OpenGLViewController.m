//
//  OpenGLViewController.m
//  PixelGridGL
//
//  Created by Ole Begemann on 24/10/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

#import "OpenGLViewController.h"
#import <OpenGLES/ES2/glext.h>

#define MAX_VERTEX_COUNT 2000

GLfloat vertexData[MAX_VERTEX_COUNT * 3];

static int currentVertexCounter = 0;

void addVertex(GLfloat x, GLfloat y, GLfloat z)
{
    assert(currentVertexCounter < MAX_VERTEX_COUNT);
    
    int vertexDataIndex = currentVertexCounter * 3;
    vertexData[vertexDataIndex + 0] = x;
    vertexData[vertexDataIndex + 1] = y;
    vertexData[vertexDataIndex + 2] = z;

    ++currentVertexCounter;
}

@interface OpenGLViewController () {
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic, readonly) GLKView *glView;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation OpenGLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (GLKView *)glView
{
    return (GLKView *)self.view;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.useConstantColor = GL_TRUE;
    

    // Hairline grid
//    for (int i = 3; i < 1920; i = i + 2) {
//        addVertex(i, 1, 0);
//        addVertex(i, 1920, 0);
//    }

    // Variable-width grid
    CGFloat step = 2.0;
    NSInteger i = 0;
    float x = 1.0;
    while (x <= 1080) {
        addVertex(x, 1, 0);
        addVertex(x, 1920, 0);
        
        ++i;
        if (i % 30 == 0) {
            step *= 2;
        }
        x += step;
    }

    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    assert(glGetError() == GL_NO_ERROR);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindVertexArrayOES(0);
    assert(glGetError() == GL_NO_ERROR);
}


- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    // Viewport = pixel coordinates
    self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.glView.drawableWidth, self.glView.drawableHeight, 0, -1, 1);
    self.effect.transform.modelviewMatrix = GLKMatrix4Identity;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glBindVertexArrayOES(_vertexArray);
    
    self.effect.constantColor = GLKVector4Make(0.0, 1.0, 0.0, 1.0);
    [self.effect prepareToDraw];
    glDrawArrays(GL_LINES, 0, currentVertexCounter);
}

@end
