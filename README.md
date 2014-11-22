# iPhone 6 Plus Rendering Test

Quick and dirty test apps to understand how the built-in downsampling to screen resolution on the iPhone 6 Plus works.

Check out the blog post: [Understanding the iPhone 6 Plus Screen](http://oleb.net/blog/2014/11/iphone-6-plus-screen/)

By [Ole Begemann](http://oleb.net), November 2014.

# Usage

There are iOS app projects: **PixelGridUIKit** (written in Swift) draws a test pattern using CoreGraphics in a normal `UIView`. **PixelGridOpenGL** (written in Objective-C) renders the same test pattern using OpenGL, skipping the scaling stage on the iPhone 6 Plus. Together, both apps illustrate the worst-case image degradation through the built-in scaling.

Note that both apps have only been tested on an iPhone 6 Plus. It’s likely that they won’t work correctly on other models (especially the OpenGL app, which hardcodes a framebuffer size of 1920 pixels).
