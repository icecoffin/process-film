# process-film

A simple tool that I use to convert my scanned film photos to the Instagram-friendly square format (by adding extra space to the sides instead of cutting off the content). Currently it's only supporting photos with an aspect ratio of 3:2 (standard 35mm format).

Another possible usage is converting images to the Instagram story format (using `--format story`). The result is a 1080x1920px image with white background. The photo content occupies 90% of the image's width. The aspect ratio requirement (see above) still applies.

The tool is implemented as a Swift package so that it can be installed using [Mint](https://github.com/yonaskolb/Mint) and used as a command-line tool. ImageMagick needs to be installed prior to using the tool (`brew install imagemagick`). This is not a showcase project, there is no proper error handling or tests.
