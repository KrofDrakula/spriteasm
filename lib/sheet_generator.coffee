fs     = require 'fs'
mkdirp = require 'mkdirp'
Canvas = require 'canvas'
Image  = Canvas.Image
printf = require 'printf'
EventEmitter = require('events').EventEmitter

class SheetGenerator extends EventEmitter

    defaults:
        maxWidth  : 1024
        maxHeight : 1024

    constructor: (options) ->
        @options =
            maxWidth  : options?.maxWidth or @defaults.maxWidth
            maxHeight : options?.maxHeight or @defaults.maxHeight
            width     : options?.width or null
            height    : options?.height or null

    generate: (images, output, cb) ->
        if @options.width is null or @options.height is null
            @getImageMetadata images[0], (err, dimensions) =>
                @assembleSheets images, dimensions, output, cb
        else
            @assembleSheets images, dimensions, output, cb
            

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

    getImageMetadata: (file, cb) ->
        fs.readFile file, (err, data) ->
            cb err if err?
            img     = new Image
            img.src = data
            cb null, { width: img.width, height: img.height}

module.exports = SheetGenerator

getDigits = (n) -> Math.ceil Math.log(n) / Math.log(10)