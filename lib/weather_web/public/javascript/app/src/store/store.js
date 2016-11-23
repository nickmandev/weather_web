import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        current_user:'',
        favorites: [],
        forecast: []
    },

    mutations:{
        setCurrentUser(state,current_user){
            state.current_user = current_user
        },

        populateFavorites(state,array){
            state.favorites = array
        },

        fetchForecast(state,array){
            state.forecast = array
        }


    }
})
