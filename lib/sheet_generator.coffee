fs     = require 'fs'
mkdirp = require 'mkdirp'
Canvas = require 'canvas'
Image  = Canvas.Image

class SheetGenerator

    maxWidth  : 1024
    maxHeight : 1024

    constructor: (options) ->
        @options = options || {}

    generate: (images, output, cb) ->
        @getImageMetadata images[0], (err, dimensions) =>
            cb err if err?
            if dimensions.width > @maxWidth or dimensions.height > @maxHeight
                throw new Error 'Frame larger than 1024px limit!'

            unless fs.existsSync output
                mkdirp.sync output

            n       = 0
            columns = Math.floor @maxWidth / dimensions.width
            rows    = Math.floor @maxHeight / dimensions.height

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

                fs.writeFile "#{output}/spritesheet-#{n}.png", canvas.toBuffer()

                n++

            cb null

    getImageMetadata: (file, cb) ->
        fs.readFile file, (err, data) ->
            cb err if err?
            img     = new Image
            img.src = data
            cb null, { width: img.width, height: img.height}



module.exports = SheetGenerator