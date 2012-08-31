optimist       = require 'optimist'
JsonPacker     = require './json_packer'
SheetGenerator = require './sheet_generator'

argv = optimist.usage('Usage: spriteasm <input-glob> -o <output-dir> [<options>]')
               .demand(['o'])
               .alias('o', 'output')
               .describe('o', "Output directory, will be created if it doesn't exist")

               .alias('w', 'width')
               .describe('w', 'Frame width in pixels (or "auto")')
               .default(w: 'auto')

               .alias('h', 'height')
               .describe('h', 'Frame height in pixels (or "auto")')
               .default(h: 'auto')

               .describe('maxWidth', 'Maximum sprite sheet width in pixels')
               .default(maxWidth: 'auto')

               .describe('maxHeight', 'Maximum sprite sheet height in pixels')
               .default(maxHeight: 'auto')

               .boolean('json')
               .describe('json', 'Encode the images as data URIs in a JSON structure')
               .default(json: false)

               .argv

opts = {
    maxWidth  : if argv.maxWidth isnt 'auto' then parseInt(argv.maxWidth, 10) else null
    maxHeight : if argv.maxHeight isnt 'auto' then parseInt(argv.maxHeight, 10) else null
    width     : if argv.width isnt 'auto' then parseInt(argv.width, 10) else null
    height    : if argv.height isnt 'auto' then parseInt(argv.height, 10) else null
}

if argv.json
    generator = new JsonPacker
else
    generator = new SheetGenerator opts

generator.on 'processStart', -> console.log 'Starting sprite sheet generation'
generator.on 'sheetReady', (name, pct) -> console.log "Finished sheet #{name}, #{pct}% complete"
generator.on 'processEnd', -> console.log 'Sprite sheet generation finished, output in ' + argv.o

generator.generate argv._, argv.o, (err) ->
    if err?
        console.error err
        return