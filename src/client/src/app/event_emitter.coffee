define ["/lib/EventEmitter.min.js"], (EventEmitter) ->
    class EventWrapper
        @emitter: new EventEmitter()

        @on: (event, listener) =>
            @emitter.addListener event, listener, @, false

        @oneShot: (event, listener) =>
            @emitter.addListener event, listener, @, true

        @fire:(type, args...) =>
            @emitter.emit type, args...

        @unbind:(event, listener) =>
            @emitter.removeListener(event, listener, @)

