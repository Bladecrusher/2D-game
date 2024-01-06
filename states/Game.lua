function Game()
    return{
        state = {
            menu = true,
            paused = false,
            running = false,
            ended = false,
            settings = false
        },
        changeGameState = function (self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
            self.state.settings = state == "settings"
        end
    }
end

return Game