define ["cs!app/event_emitter","cs!app/views/drawing_view"], (EventEmitter, View) ->
    class DrawingController
        @pictoCoordsToCanvas: (coords) =>
            coords[0] *= @scaleX
            coords[1] *= @scaleY
            [parseInt(coords[0]), parseInt(coords[1])]

        @canvasCoordsToPicto: (coords) =>
            coords[0] /= @scaleX
            coords[1] /= @scaleY
            coords

        #send drawing out to huru
        @startDrawing: (data) =>
            @huru.send ["drawing","start", @canvasCoordsToPicto(data).join " "]
        @updateDrawing: (data) =>
            result = @canvasCoordsToPicto(data)
            @huru.send ["drawing","update", result.join " "]
        @endDrawing: (data) =>
            @huru.send ["drawing","end", @canvasCoordsToPicto(data).join " "]

        #send drawing from huru to canvas
        @onUpdate:(data) =>
            console.log "update drawing with remote data", data
            View.updateDrawing @pictoCoordsToCanvas data
        @onStart:(data) =>
            View.startDrawing @pictoCoordsToCanvas data
        @onEnd:(data) =>
            View.endDrawing @pictoCoordsToCanvas data

        @processMessage:(message) =>
            point = message[1].split " "
            point = (parseInt(p) for p in point)

            switch message[0]
                when "update", "end"
                    @onUpdate point
                when "start"
                    @onStart point

        @setScale: (scale) =>
            @scaleX = scale[0]
            @scaleY = scale[1]

        @init:(router, @huru) =>
            EventEmitter.on "start_drawing", @startDrawing
            EventEmitter.on "end_drawing", @endDrawing
            EventEmitter.on "update_drawing", @updateDrawing

            EventEmitter.on "set_canvas_scale", @setScale

            router.addMessageCallback "drawing", @processMessage 

