Spriteasm
=========

Animation sprite generation made easy.

On mobile devices, animating anything beyong manipulating transforms and
opacity is usually limited to using GIF animations and elaborate use of
the canvas element. Both of these have their drawbacks – they're prohibitively
expensive CPU-bound operations. HTML5 inline video is supported on some devices,
but also suffers glitches, inconsistencies and rendering artifacts which break
experiences. Also, video doesn't support alpha transparency and you'd be
hard-pressed to create animated overlays.

Enter sprite sheet animation.

While this tool does not provide any JS implementations for said process, it
does ease the problem of generating sprite sheets out of individual frames into
combined sprite sheets, split into 1024×1024 chunks (maximum allowed image size
before downsampling occurs).

This tool uses the node implementation of `canvas` to generate PNG sprite sheets.
It also respects transparency of the original frames in the output.

It does not convert or optimize the final sprite sheets, so use whatever favourite
tools you have at your disposal to transcode the final images.

Usage
-----

    spriteasm *.png -o output-dir

The tool assumes all frames are of the same size and measures the size of the
first frame matched by the glob pattern.


Performance
-----------

I've timed the performance on a sample set of 2,232 PNG frames (320×180), totalling
154 MB. I ran the test on a VirtualBox instance of Ubuntu 32-bit on an
EliteBook 8540p.

The results:

149 sprite sheets (960×900): 96 MB

    real    0m56.409s
    user    0m55.996s
    sys     0m2.248s