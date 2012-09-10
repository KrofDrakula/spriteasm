fs            = require 'fs'
path          = require 'path'
mkdirp        = require 'mkdirp'
printf        = require 'printf'
Canvas        = require 'canvas'
Image         = Canvas.Image
BaseGenerator = require './base_generator'

class JsonPacker extends BaseGenerator
    
    assembleSheets: (images, dimensions, output, cb) ->
        @emit 'processStart'

        encoded = {}
        done = 0

        canvas = new Canvas dimensions.width, dimensions.height
        ctx = canvas.getContext '2d'

        for idx in [0...images.length]
            do =>
                ctx.clearRect 0, 0, canvas.width, canvas.height
                currentIndex = idx
                file = images[currentIndex]

                fs.readFile file, (err, data) =>

                    mime = @mapExtensionToMimeType path.extname file

                    img = new Image
                    img.src = "data:#{mime};base64," + data.toString('base64');

                    ctx.drawImage img, 0, 0, dimensions.width, dimensions.height

                    encoded[path.basename(file)] = canvas.toDataURL()

                    done++

                    if Object.keys(encoded).length is images.length
                        unless fs.existsSync path.dirname(output)
                            mkdirp.sync path.dirname(output)
                        fs.writeFile output, JSON.stringify(encoded), (err) =>
                            @emit 'processEnd'
                            cb if err? then err else null
                    @emit 'sheetReady', file, printf('%.2f', (done / images.length) * 100)


    mapExtensionToMimeType: (ext) ->
        switch ext.toLowerCase()
            when '.jpe', '.jpg', '.jpeg'
                return 'image/jpeg'
            when '.png'
                return 'image/png'
            when '.gif'
                return 'image/gif'
            else
                return 'text/plain'

module.exports = JsonPacker