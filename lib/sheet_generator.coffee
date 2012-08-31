fs            = require 'fs'
mkdirp        = require 'mkdirp'
Canvas        = require 'canvas'
Image         = Canvas.Image
printf        = require 'printf'
BaseGenerator = require './base_generator'

class SheetGenerator extends BaseGenerator

    defaults:
        maxWidth  : 1024
        maxHeight : 1024

    constructor: (options) ->
        super
        @options.maxWidth  = options?.maxWidth or @defaults.maxWidth
        @options.maxHeight = options?.maxHeight or @defaults.maxHeight

    assembleSheets: (images, dimensions, output, cb) ->
        @emit 'processStart'
        if dimensions.width > @options.maxWidth or dimensions.height > @options.maxHeight
            throw new Error 'Frame larger than 1024px limit!'

        unless fs.existsSync output
            mkdirp.sync output

        n         = 0
        columns   = Math.floor @options.maxWidth / dimensions.width
        rows      = Math.floor @options.maxHeight / dimensions.height
        digits    = getDigits images.length / (columns * rows)
        allImages = images.length

        while images.length > 0
            selected = images.slice 0, columns * rows
            images   = images.slice columns * rows

            canvas = new Canvas dimensions.width * columns, dimensions.height * rows
            ctx = canvas.getContext '2d'

            for i in [0...selected.length]
                img = new Image
                img.src = fs.readFileSync selected[i]
                x = (i % columns) * dimensions.width
                y = Math.floor(i / columns) * dimensions.height
                ctx.drawImage img, x, y, dimensions.width, dimensions.height

            seqNum = printf "%0#{digits}d", n

            percentComplete = printf "%.2f", (1 - (images.length) / allImages) * 100

            fs.writeFile "#{output}/spritesheet-#{seqNum}.png", canvas.toBuffer()

            @emit 'sheetReady', seqNum, percentComplete

            n++

        @emit 'processEnd'
        cb null

module.exports = SheetGenerator

getDigits = (n) -> Math.ceil Math.log(n) / Math.log(10)