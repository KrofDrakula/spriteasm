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

The frames themselves are arranged left-to-right, top-to-bottom, in that order.

This tool uses the node implementation of `canvas` to generate PNG sprite sheets.
It also respects transparency of the original frames in the output.

It does not convert or optimize the final sprite sheets, so use whatever favourite
tools you have at your disposal to transcode the final images.

Optionally, the script can generate a JSON object containing the file names mapped
to a data URI for each of the encoded files by using the `--json` option when
invoking the command.


Sprite animation performance on WebKit
--------------------------------------

Before implementing web sprite sheet animations, you might consider reading [this
article](http://gist.io/3639830). It covers mobile and desktop sprite animation performance which you should
be aware of before planning use of such graphics.


Usage
-----

    spriteasm *.png -o output-dir [options]

The tool assumes all frames are of the same size and measures the size of the
first frame matched by the glob pattern.

Run `spriteasm` without arguments to see the list of available options.


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
