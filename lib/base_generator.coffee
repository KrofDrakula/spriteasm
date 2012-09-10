fs           = require 'fs'
Image       = require('canvas').Image
EventEmitter = require('events').EventEmitter

class BaseGenerator extends EventEmitter

    constructor: (options) ->
        @options =
            width  : options?.width or null
            height : options?.height or null

    generate: (images, output, cb) ->
        if @options.width is null or @options.height is null
            @getImageMetadata images[0], (err, dimensions) =>
                @assembleSheets images, dimensions, output, cb
        else
            @assembleSheets images, { width: @options.width, height: @options.height }, output, cb

    assembleSheets: (images, dimensions, output, cb) ->
        throw new Error 'Not implemented'

    getImageMetadata: (file, cb) ->
        fs.readFile file, (err, data) ->
            cb err if err?
            img     = new Image
            img.src = data
            cb null, { width: img.width, height: img.height }

module.exports = BaseGenerator