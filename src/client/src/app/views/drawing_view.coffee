define ["jquery","cs!app/event_emitter"], ($, Emitter) ->
    class DrawingView
        @scrawl:[]
        @currentLine:[]

        @drawing:false
        @context:"wat"

        @addView: =>
            $("#game-container").empty()
            $("#game-container").append """<div class="drawing-container"><canvas width=140 height=100 id="drawing-canvas"><canvas></div>"""

            #$("#drawing-canvas").on "touchmove", @touchMoveHandler

            $("#drawing-canvas").on "mousedown", @mouseDownHandler
            $("#drawing-canvas").on "mousemove", @mouseMoveHandler
            $("#drawing-canvas").on "mouseup", @mouseUpHandler

            @canvas = $("#drawing-canvas")[0]
            @canvas.addEventListener "touchmove", @touchMoveHandler, true
            @canvas.addEventListener "touchstart", @touchDownHandler, true
            @canvas.addEventListener "touchend", @touchEndHandler, true

            @expandCanvas()

        @expandCanvas: =>
            canvas =$("#drawing-canvas")
            canvas[0].width = canvas.parent().width()
            scaleX = canvas.width() / 1400

            canvas[0].height = canvas.parent().height()
            scaleY = canvas.height() / 1000

            @context = $("#drawing-canvas")[0].getContext("2d")
            @context.strokeStyle = "#000000"
            @context.lineWidth = 5

            Emitter.fire "set_canvas_scale", [scaleX, scaleY]

        @touchDownHandler: (event) =>
            if not @drawing
                @drawing = true

                event.preventDefault()

                x = event.targetTouches[0].clientX - @canvas.offsetLeft
                y = event.targetTouches[0].clientY - @canvas.offsetTop

                @startDrawing [x,y]

                Emitter.fire "start_drawing", [x,y]

        @touchMoveHandler: (event) =>
            if @drawing

                event.preventDefault()

                x = event.targetTouches[0].pageX - @canvas.offsetLeft
                y = event.targetTouches[0].pageY - @canvas.offsetTop

                @updateDrawing [x,y]
                Emitter.fire "update_drawing", [x,y]

        @touchEndHandler: (event) =>
            if @drawing
                @drawing = false

                event.preventDefault()

                x = event.targetTouches[0].pageX - @canvas.offsetLeft
                y = event.targetTouches[0].pageY - @canvas.offsetTop

                @endDrawing [x,y]
                Emitter.fire "end_drawing", [x,y]

# mouse handlers

        @mouseDownHandler: (event) =>
            if not @drawing
                @drawing = true

                startPoint = [event.offsetX,event.offsetY]
                @startDrawing startPoint
                Emitter.fire "start_drawing", startPoint

        @mouseMoveHandler: (event) =>
            if @drawing
                point = [event.offsetX,event.offsetY]

                @updateDrawing(point)
                Emitter.fire "update_drawing", point

        @mouseUpHandler: (event) =>
            if @drawing
                @drawing = false
                point = [event.offsetX,event.offsetY]

                @endDrawing point
                Emitter.fire "end_drawing", point
            #
#drawing methods

        @startDrawing:(point) =>
            @currentLine.push point
            @context.strokeStyle = "#000000"
            @context.moveTo point...

        @updateDrawing:(point) =>
            @currentLine.push point
            @context.lineWidth = 5
            @context.lineTo point...
            @context.stroke()


        @endDrawing:(point) =>
            @updateDrawing point
            @currentLine.push point


            @scrawl.push @currentLine
            @currentLine = []

