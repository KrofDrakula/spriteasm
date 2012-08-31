fs            = require 'fs'
path          = require 'path'
mkdirp        = require 'mkdirp'
printf        = require 'printf'
BaseGenerator = require './base_generator'

class JsonPacker extends BaseGenerator
    
    assembleSheets: (images, dimensions, output, cb) ->
        @emit 'processStart'

        encoded = {}
        done = 0
        for idx in [0...images.length]
            do =>
                currentIndex = idx
                file = images[currentIndex]
                fs.readFile file, (err, data) =>
                    mime = @mapExtensionToMimeType path.extname file
                    encoded[path.basename(file)] = "data:#{mime};base64," + data.toString('base64')
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