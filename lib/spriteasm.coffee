optimist       = require 'optimist'
SheetGenerator = require './sheet_generator'

argv = optimist.usage('Usage: spriteasm -o output-dir [-i file-glob]')
               .alias('i', 'input')
               .describe('i', 'Input file glob pattern, usually *.png')
               .default(i: '*.png')
               .demand(['o'])
               .alias('o', 'output')
               .describe('o', "Output directory, will be created if it doesn't exist")
               .argv

sg = new SheetGenerator
sg.generate argv._, argv.o, (err) ->
    if err?
        console.error err
        return

    console.log "Generated sprite sheets in #{argv.o}"